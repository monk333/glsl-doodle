(window.webpackJsonp=window.webpackJsonp||[]).push([[101],{546:function(n,e,d){"use strict";d.r(e),e.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <graphics>\n#pragma include <color>\n#pragma include <pattern>\n\nuniform vec2 dd_resolution;\nuniform vec2 dd_randseed0;\n\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution.xy;\n  st = mix(vec2(-10, -10), vec2(10, 10), st);\n  gl_FragColor = vec4(vec3(mist(st + dd_randseed0)), 1.0);\n}"}}]);