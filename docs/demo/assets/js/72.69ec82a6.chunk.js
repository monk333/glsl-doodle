(window.webpackJsonp=window.webpackJsonp||[]).push([[72],{515:function(n,r,e){"use strict";e.r(r),r.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <graphics>\n\nuniform vec2 dd_resolution;\n\nfloat f(float x) {\n  // return sin(x * 2.0 * PI);\n  // return cos(x * 2.0 * PI);\n  // return 2.0 * x;\n  // return 0.1 / (x + 0.02);\n  // return smoothstep(0.1, 0.9, x);\n  return x * x;\n}\n\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution;\n  st = mix(vec2(-5), vec2(5), st);\n  float d = PLOT(f, st, 0.01);\n  gl_FragColor.rgb = (step(-0.05, d) - step(0.05, d)) * vec3(1.0);\n  gl_FragColor.a = 1.0;\n}"}}]);