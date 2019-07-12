(window.webpackJsonp=window.webpackJsonp||[]).push([[102],{545:function(n,d,i){"use strict";i.r(d),d.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <stdlib>\n#pragma include <graph>\n#pragma include <color>\n#pragma include <pattern>\n\nuniform vec2 dd_resolution;\nuniform vec2 dd_randseed0;\n\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution;\n  vec2 grid = vec2(10, 10);\n  vec2 idx = grid_index(st, grid);\n\n  st = grid_xy(st, grid);\n  st = mix(vec2(-10, -10), vec2(10, 10), st);\n  \n  float pct = 1.0;\n\n  if(random(idx + dd_randseed0) > 0.5) {\n    if(grid_odd_row(idx, grid)) {\n      st = scale(st, vec2(-1.0, -1.0));\n    }\n\n    if(grid_odd(idx, grid)) {\n      pct = sdf_triangle(st, vec2(10, -10), vec2(10, 10), vec2(-10, 10));\n    } else {\n      pct = sdf_triangle(st, vec2(-10, -10), vec2(-10, 10), vec2(10, 10));\n    }\n\n    color(fill(pct, 0.05), random3(idx));\n  }\n}"}}]);