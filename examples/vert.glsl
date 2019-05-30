#ifdef GL_ES
precision mediump float;
#endif

attribute vec4 a_position;

void main() {
  gl_PointSize = 1.0;
  gl_Position.x = a_position.x;
  gl_Position.y = a_position.y;
  gl_Position.z = a_position.z;
  gl_Position.w = 1.0;
}