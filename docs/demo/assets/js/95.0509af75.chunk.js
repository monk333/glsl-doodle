(window.webpackJsonp=window.webpackJsonp||[]).push([[95],{538:function(n,e,d){"use strict";d.r(e),e.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <stdlib>\n#pragma include <graph>\n#pragma include <color>\n#pragma include <pattern>\n\nuniform float dd_time;\nuniform vec2 dd_resolution;\nuniform vec2 dd_randseed;\nuniform vec2 dd_randseed0;\n\n// http://www.pouet.net/prod.php?which=57245\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution;\n\n  vec2 r = dd_resolution.xy;\n  float t = dd_time;\n\n  vec3 c;\n  float l, z = t;  \n\n  for(int i = 0; i < 3; i++) {\n    vec2 uv, p = st;\n    uv = p;\n    p -= 0.5;\n    p.x *= r.x / r.y;\n    z += 0.07;\n    l = length(p);\n    uv += p / l * (sin(z) + 1.0) * abs(sin(l * 9.0 - z * 2.0));\n    c[i] = 0.01 / length(abs(mod(uv, 1.0) - 0.5));\n  }\n\n  gl_FragColor = vec4(c/l, t);\n}"}}]);