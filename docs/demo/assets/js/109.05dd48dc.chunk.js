(window.webpackJsonp=window.webpackJsonp||[]).push([[109],{554:function(n,o,e){"use strict";e.r(o),o.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <graphics>\n\nuniform vec2 dd_resolution;\n\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution;\n  st = mix(vec2(-5), vec2(5), st);\n  float d = sdf_circle(st, vec2(0), 0.5);\n  d = stroke(fract(abs(d)), 0.5, 0.1, 0.1);\n  gl_FragColor.rgb = d * vec3(1.0);\n  gl_FragColor.a = 1.0;\n}"}}]);