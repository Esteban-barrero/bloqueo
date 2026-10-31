package com.example.bloqueo

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

/**
 * Servicio de accesibilidad que detecta cuando el usuario abre una aplicación
 * bloqueada y muestra un overlay con la pantalla de bloqueo (cosmica).
 *
 * Lee la configuración que Flutter guarda en SharedPreferences:
 *   - flutter.bloqueos_nativo : JSON con los bloqueos (appPackage, tipo, dias,
 *     horarios, duracion, mensaje, creadoEnMs).
 *   - flutter.bloqueos        : JSON con los bloqueos completos (para sincronizar
 *     cuando se pulsa "Desbloquear").
 */
class ServicioBloqueo : AccessibilityService() {

    private var ventana: WindowManager? = null
    private var overlay: View? = null
    private var paqueteBloqueado: String? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        ventana = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val pkg = event.packageName?.toString() ?: return
        if (pkg == packageName) return

        val bloqueo = buscarBloqueoVigente(pkg)
        if (bloqueo == null) {
            // Si estaba mostrando el overlay y cambio de app, lo quitamos.
            if (overlay != null && pkg != paqueteBloqueado) quitarOverlay()
            return
        }

        if (overlay != null && paqueteBloqueado == pkg) return
        paqueteBloqueado = pkg
        mostrarOverlay(bloqueo.first, bloqueo.second)
    }

    override fun onInterrupt() {
        quitarOverlay()
    }

    override fun onDestroy() {
        quitarOverlay()
        super.onDestroy()
    }

    /** Busca un bloqueo vigente para el paquete indicado. */
    private fun buscarBloqueoVigente(pkg: String): Pair<String, String>? {
        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val raw = prefs.getString("flutter.bloqueos_nativo", null) ?: return null
        return try {
            val arr = JSONArray(raw)
            val ahora = Calendar.getInstance()
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                if (o.optString("appPackage") != pkg) continue
                if (!o.optBoolean("activo", true)) continue
                if (estaVigente(o, ahora)) {
                    val nombre = o.optString("appNombre", pkg)
                    val mensaje = o.optString("mensaje", "Oye, no pierdas el tiempo...")
                    return Pair(nombre, mensaje)
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }

    /** Evalua si el bloqueo esta vigente (horario o tiempo). */
    private fun estaVigente(o: JSONObject, ahora: Calendar): Boolean {
        return if (o.optString("tipo", "tiempo") == "tiempo") {
            val creado = o.optLong("creadoEnMs", 0L)
            if (creado <= 0L) return false
            val minutos = o.optInt("duracionMinutos", 0)
            System.currentTimeMillis() <= creado + minutos * 60_000L
        } else {
            val dias = o.optJSONArray("diasSemana") ?: return false
            val dia = ahora.get(Calendar.DAY_OF_WEEK) - 1 // 0=domingo..6=sabado
            var contiene = false
            for (i in 0 until dias.length()) {
                if (dias.optInt(i) == dia) {
                    contiene = true
                    break
                }
            }
            if (!contiene) return false
            val min = ahora.get(Calendar.HOUR_OF_DAY) * 60 + ahora.get(Calendar.MINUTE)
            val ini = o.optInt("horaInicio", 0)
            val fin = o.optInt("horaFin", 0)
            if (ini <= fin) min in ini until fin else (min >= ini || min < fin)
        }
    }

    /** Muestra el overlay cosmico sobre la app bloqueada. */
    private fun mostrarOverlay(nombreApp: String, mensaje: String) {
        quitarOverlay()

        val raiz = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(70, 70, 70, 70)
            background = GradientDrawable(
                GradientDrawable.Orientation.TL_BR,
                intArrayOf(
                    Color.parseColor("#0B0033"),
                    Color.parseColor("#12003A"),
                    Color.parseColor("#050512")
                )
            )
        }

        val icono = TextView(this).apply {
            text = "\uD83D\uDD12" // 🔒
            textSize = 52f
            gravity = Gravity.CENTER
        }

        val titulo = TextView(this).apply {
            text = "Está bloqueado"
            textSize = 30f
            setTextColor(Color.WHITE)
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            setPadding(0, 16, 0, 0)
        }

        val app = TextView(this).apply {
            text = nombreApp
            textSize = 18f
            setTextColor(Color.parseColor("#B0FFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, 6, 0, 0)
        }

        val cuerpo = TextView(this).apply {
            text = mensaje
            textSize = 19f
            setTextColor(Color.parseColor("#E6FFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, 40, 0, 46)
        }

        val btnDesbloquear = Button(this).apply {
            text = "Desbloquear"
            setTextColor(Color.WHITE)
            textSize = 16f
            isAllCaps = false
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#7B2FF7"))
                cornerRadius = 46f
            }
            setOnClickListener {
                desbloquear(paqueteBloqueado)
                quitarOverlay()
                performGlobalAction(GLOBAL_ACTION_HOME)
            }
        }

        val btnSalir = Button(this).apply {
            text = "Salir"
            setTextColor(Color.WHITE)
            textSize = 16f
            isAllCaps = false
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#22FFFFFF"))
                cornerRadius = 46f
            }
            setOnClickListener {
                quitarOverlay()
                performGlobalAction(GLOBAL_ACTION_HOME)
            }
        }

        raiz.addView(icono, ancho(LinearLayout.LayoutParams.WRAP_CONTENT, 0))
        raiz.addView(titulo, ancho(LinearLayout.LayoutParams.MATCH_PARENT, 0))
        raiz.addView(app, ancho(LinearLayout.LayoutParams.MATCH_PARENT, 0))
        raiz.addView(cuerpo, ancho(LinearLayout.LayoutParams.MATCH_PARENT, 0))
        val lpBoton = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        lpBoton.setMargins(0, 0, 0, 18)
        raiz.addView(btnDesbloquear, lpBoton)
        raiz.addView(btnSalir, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ))

        val tipo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            tipo,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.CENTER

        try {
            ventana?.addView(raiz, params)
            overlay = raiz
        } catch (e: Exception) {
            overlay = null
        }
    }

    private fun ancho(ancho: Int, margenTop: Int): LinearLayout.LayoutParams {
        return LinearLayout.LayoutParams(ancho, LinearLayout.LayoutParams.WRAP_CONTENT).apply {
            topMargin = margenTop
        }
    }

    private fun quitarOverlay() {
        if (overlay != null) {
            try {
                ventana?.removeView(overlay)
            } catch (e: Exception) {
                // Ignorar si ya fue removido.
            }
            overlay = null
        }
        paqueteBloqueado = null
    }

    /** Elimina el bloqueo del paquete en la configuracion local. */
    private fun desbloquear(pkg: String?) {
        if (pkg == null) return
        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        eliminarDeClave(prefs, "flutter.bloqueos_nativo", pkg)
        eliminarDeClave(prefs, "flutter.bloqueos", pkg)
    }

    private fun eliminarDeClave(
        prefs: android.content.SharedPreferences,
        clave: String,
        pkg: String
    ) {
        val raw = prefs.getString(clave, null) ?: return
        try {
            val arr = JSONArray(raw)
            val nuevo = JSONArray()
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                if (o.optString("appPackage") != pkg) nuevo.put(o)
            }
            prefs.edit().putString(clave, nuevo.toString()).apply()
        } catch (e: Exception) {
            // Ignorar JSON invalido.
        }
    }
}
