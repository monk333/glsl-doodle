(window.webpackJsonp=window.webpackJsonp||[]).push([[70],{513:function(o,n,e){"use strict";e.r(n),n.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform vec2 dd_resolution;\n\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution;\n  float d = smoothstep(0.0, 0.3, st.x) - smoothstep(0.7, 1.0, st.x);\n  gl_FragColor.rgb = d * vec3(1.0);\n  gl_FragColor.a = 1.0;\n}"}}]);