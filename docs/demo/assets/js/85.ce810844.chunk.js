(window.webpackJsonp=window.webpackJsonp||[]).push([[85],{529:function(n,o,e){"use strict";e.r(o),o.default="(async function () {\n  const fragment = `\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float u_count;\n\nvoid main() {\ngl_FragColor = (0.5 + 0.5 * sin(0.05 * u_count)) * vec4(1, 0, 0, 1);\n}\n`;\n\n  const doodle = new Doodle(document.getElementById('myDoodle'));\n  const program = await doodle.compile(fragment);\n  doodle.useProgram(program);\n  doodle.uniforms.u_count = 0;\n  requestAnimationFrame(function update() {\n    doodle.uniforms.u_count++;\n    requestAnimationFrame(update);\n  });\n  doodle.render();\n}());"}}]);