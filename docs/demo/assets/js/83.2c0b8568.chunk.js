(window.webpackJsonp=window.webpackJsonp||[]).push([[83],{534:function(n,o,e){"use strict";e.r(o),o.default="(async function () {\n  const vert = `\nattribute vec4 a_vertexPosition;\nattribute vec3 a_color;\n\nvarying vec3 vColor;\n\nvoid main() {\ngl_PointSize = 1.0;\ngl_Position = a_vertexPosition;\nvColor = a_color;\n}\n`;\n  const fragment = `\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nvarying vec3 vColor;\n\nvoid main() {\ngl_FragColor = vec4(vColor, 1.0);\n}\n`;\n\n  const doodle = new Doodle(document.getElementById('myDoodle'));\n  const program = await doodle.compile(fragment, vert);\n  doodle.useProgram(program);\n\n  const vertexColors = [\n    [255, 0, 0],\n    [255, 0, 0],\n    [255, 255, 0],\n  ];\n\n  doodle.setMeshData([\n    {\n      positions: [[-1.0, -1.0, 0.0], [-1.0, 1.0, 0.0], [1.0, 1.0, 0.0]],\n      cells: [[0, 1, 2]],\n      attributes: {\n        a_color: {data: vertexColors, type: 'UNSIGNED_BYTE', normalize: true},\n      },\n    },\n    {\n      positions: [[0.5, 0.5, 0], [-0.5, 0.8, 0], [1, -1, 0]],\n      cells: [[0, 1, 2]],\n      attributes: {\n        a_color: {data: vertexColors, type: 'UNSIGNED_BYTE', normalize: true},\n      },\n    },\n  ]);\n\n  doodle.render();\n}());"}}]);