(window.webpackJsonp=window.webpackJsonp||[]).push([[96],{541:function(n,e,i){"use strict";i.r(e),e.default="#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#pragma include <stdlib>\n#pragma include <graph>\n#pragma include <color>\n#pragma include <pattern>\n\nuniform float dd_time;\nuniform vec2 dd_resolution;\nuniform vec2 dd_randseed;\nuniform vec2 dd_randseed0;\n\n// https://thebookofshaders.com/12/\nvoid main() {\n  vec2 st = gl_FragCoord.xy / dd_resolution.xy;\n  st.x *= dd_resolution.x / dd_resolution.y;\n  \n  vec3 color = vec3(.0);\n\n  // Tile the space\n  vec2 grid = vec2(6.0, 6.0);\n  vec2 i_st = grid_index(st, grid);\n  vec2 f_st = grid_xy(st, grid);\n\n  float m_dist = 1.0;  // minimun distance\n\n  for (int y= -1; y <= 1; y++) {\n    for (int x= -1; x <= 1; x++) {\n      // Neighbor place in the grid\n      vec2 neighbor = vec2(float(x), float(y));\n\n      // Random position from current + neighbor place in the grid\n      vec2 point = random2(i_st + neighbor);\n\n      // Animate the point\n      point = 0.5 + 0.5 * sin(dd_time + 6.2831 * point);\n\n      // Vector between the pixel and the point\n      vec2 diff = neighbor + point - f_st;\n\n      // Distance to the point\n      float dist = length(diff);\n\n      // Keep the closer distance\n      m_dist = min(m_dist, dist);\n    }\n  }\n\n  // Draw the min distance (distance field)\n  color += m_dist;\n\n  // Draw cell center\n  color += 1.0 - step(0.02, m_dist);\n\n  // Draw grid\n  // color.r += step(0.98, f_st.x) + step(0.98, f_st.y);\n\n  // Show isolines\n  // color -= step(.7,abs(sin(27.0*m_dist)))*.5;\n\n  gl_FragColor = vec4(color, 1.0);\n}\n"}}]);