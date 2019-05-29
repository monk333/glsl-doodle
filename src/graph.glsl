#ifndef M_GRAPH

#define M_GRAPH

#pragma include <stdlib>

/**
  有向距离场
 */
#define SDF float

/**
  定义： Unit Distance Field 单位距离场，值从 0.0~1.0，无限远处为0.0，最近处为1.0
  stroke 和 fill 的时候取距离场的切面
 */
#define UDF float

/**
  PLOT宏，用来绘制连续函数曲线
  注意：PLOT适合绘制连续曲线，在局部不连续处可能失真

  参数：
    function f  曲线方程 y = f(x)
    vec2 st     当前绘图坐标
    float step  曲线采样间隔
    float th    线条宽度
    float smth  边缘模糊率，用于消除锯齿
  
  返回值：
    UDF  距离场
*/
#define PLOT(f, st, step) plot_distance(st, vec2(st.x - step, f(st.x - step)), vec2(st.x, f(st.x)), vec2(st.x + step, f(st.x + step)))

#define SPRITE(quad, f) if(quad.x >= 0.0 && quad.x <= 1.0) f(quad);

/**
  点到直线的距离
 */
float line_distance(in vec2 p, in vec2 v1, in vec2 v2) {
  vec2 pd = p - v1;
  vec2 pd2 = p - v2;
  vec2 seg = v2 - v1;

  return (pd.x * seg.y - pd.y * seg.x) / length(seg);
}

#define sdf_line line_distance

/**
  点到线段的距离

  参数：
    vec2 p  点坐标
    vec2 v1 线段端点坐标
    vec2 v2 线段端点坐标

  返回值：
    float   距离
 */
float seg_distance(in vec2 p, in vec2 v1, in vec2 v2) {
  vec2 pd = p - v1;
  vec2 pd2 = p - v2;
  vec2 seg = v2 - v1;

  float l = length(seg);
  float d = abs(pd.x * seg.y - pd.y * seg.x) / l;
  float proj = (pd.x * seg.x + pd.y * seg.y) / l;

  if(proj >= 0.0 && proj <= l) return d;

  return min(length(pd), length(pd2));
}

#define sdf_seg seg_distance
#define line_seg seg_distance

/**
  取 p 到线段 v1v2 和 v2v3 两者中最近的距离

  参数：
    vec2 p 点坐标
    vec2 v1 线段端点坐标
    vec2 v2 线段端点坐标
    vec2 v3 线段端点坐标

  返回值：
    float 距离
 */
float plot_distance(in vec2 p, in vec2 v1, in vec2 v2, in vec2 v3) {
  float d1 = seg_distance(p, v1, v2);
  float d2 = seg_distance(p, v2, v3);

  return min(d1, d2);
}

/**
  将距离转换为单位距离场：UDF

  参数：
    float d 距离
    float w 范围
    float smth 边缘模糊率
 */
UDF distance_to_udf(in float d, in float w, in float smth) {
  float th = 0.5 * w;
  smth = smth * w;
  return smoothstep(-th, smth - th, d) - smoothstep(th - smth, th, d);
}

UDF stroke(in SDF d, in float d0, in float w, in float smth) {
  float th = 0.5 * w;
  smth = smth * w;
  float start = d0 - th;
  float end = d0 + th; 
  return smoothstep(start, start + smth, d) - smoothstep(end - smth, end, d);
}

UDF stroke(in SDF d, in float w, in float smth) {
  return stroke(d, 0.0, w, smth);
}

/**
  三角形的 SDF
 */
SDF sdf_triangle(in vec2 st, in vec2 a, in vec2 b, in vec2 c) {
  vec2 va = a - b;
  vec2 vb = b - c;
  vec2 vc = c - a;

  float d1 = sdf_line(st, a, b);
  float d2 = sdf_line(st, b, c);
  float d3 = sdf_line(st, c, a);

  // 三角形内切圆半径
  float l = abs(va.x * vb.y - va.y * vb.x) / (length(va) + length(vb) + length(vc));

  if(d1 >= 0.0 && d2 >= 0.0 && d3 >= 0.0 || d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0) {
    return min(abs(d1), min(abs(d2), abs(d3))) / l;
  }

  d1 = sdf_seg(st, a, b);
  d2 = sdf_seg(st, b, c);
  d3 = sdf_seg(st, c, a);
  return -min(abs(d1), min(abs(d2), abs(d3))) / l;
}

SDF sdf_rect(in vec2 st, in vec2 p, float w, float h) {
  vec2 a = p;
  vec2 b = p + vec2(w, 0.0);
  vec2 c = p + vec2(w, h);
  vec2 d = p + vec2(0.0, h);

  vec2 va = a - b;
  vec2 vb = b - c;
  vec2 vc = c - d;
  vec2 vd = d - a;

  float d1 = sdf_line(st, a, b);
  float d2 = sdf_line(st, b, c);
  float d3 = sdf_line(st, c, d);
  float d4 = sdf_line(st, d, a);

  float l = min(w, h) * 0.5; // 矩形短边

  if(d1 >= 0.0 && d2 >= 0.0 && d3 >= 0.0 && d4 >= 0.0 ||
     d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0 && d4 <= 0.0) {
    return min(abs(d1), min(abs(d2), min(abs(d3), abs(d4)))) / l;
  }

  d1 = sdf_seg(st, a, b);
  d2 = sdf_seg(st, b, c);
  d3 = sdf_seg(st, c, d);
  d4 = sdf_seg(st, d, a);

  return -min(abs(d1), min(abs(d2), min(abs(d3), abs(d4)))) / l;
}

SDF sdf_circle(in vec2 st, in vec2 c, float r) {
  return 1.0 - length(st - c) / r;
}

SDF sdf_ellipse(in vec2 st, in vec2 c, in float a, in float b) {
  vec2 p = st - c;
  return 1.0 - sqrt(pow(p.x / a, 2.0) + pow(p.y / b, 2.0));
}

SDF sdf_ellipse(in vec2 st, in vec2 c, in float a, in float b, in float sAng, in float eAng) {
  vec2 ua = vec2(cos(sAng), sin(sAng));
  vec2 ub = vec2(cos(eAng), sin(eAng));

  float d1 = sdf_line(st, c, ua + c);
  float d2 = sdf_line(st, c, ub + c);

  float d3 = sdf_ellipse(st, c, a, b);
  float r = min(a, b);

  vec2 v = st - c;
  float ang = angle(v, vec2(1.0, 0));

  if(eAng - sAng > 2.0 * PI) {
    return d3;
  }

  if(ang >= sAng && ang <= eAng) { // 两个向量夹角中间的部分
    float m = max(a, b);
    float d11 = sdf_seg(st, c, ua * m + c);
    float d12 = sdf_seg(st, c, ub * m + c);
    if(d3 >= 0.0) {
      return min(abs(d11 / r), min(abs(d12 / r), d3));
    }
    return d3;
  }
  
  float pa = dot(ua, v); // 求投影
  float pb = dot(ub, v);

  if(pa < 0.0 && pb < 0.0) {
    return -length(st - c) / r;
  }

  if(d1 > 0.0 && pa >= 0.0) {
    vec2 va = pa * ua;
    float da = pow(va.x / a, 2.0) + pow(va.y / b, 2.0);
    if(d3 > 0.0 || da <= pow(1.0 + abs(d1 / r), 2.0)) {
      return -abs(d1 / r);
    } else {
      return d3;
    }
  }

  if(d2 < 0.0 && pb >= 0.0) {
    vec2 vb = pb * ub;
    float db = pow(vb.x / a, 2.0) + pow(vb.y / b, 2.0);
    if(d3 >= 0.0 || db <= pow(1.0 + abs(d2 / r), 2.0)) {
      return -abs(d2 / r);
    } else {
      return d3;
    }
  }
}

SDF sdf_arc(in vec2 st, in vec2 c, float r, in float sAng, in float eAng) {
  return sdf_ellipse(st, c, r, r, sAng, eAng);
}

SDF sdf_rhombus(in vec2 st, in vec2 cr, float w, float h) {
  vec2 a = cr - vec2(0.5 * w, 0);
  vec2 b = cr - vec2(0, 0.5 * h);
  vec2 c = cr + vec2(0.5 * w, 0);
  vec2 d = cr + vec2(0, 0.5 * h);

  vec2 va = a - b;
  vec2 vb = b - c;
  vec2 vc = c - d;
  vec2 vd = d - a;

  float d1 = sdf_line(st, a, b);
  float d2 = sdf_line(st, b, c);
  float d3 = sdf_line(st, c, d);
  float d4 = sdf_line(st, d, a);

  float l = min(w, h) * 0.5; // 矩形短边

  if(d1 >= 0.0 && d2 >= 0.0 && d3 >= 0.0 && d4 >= 0.0 ||
     d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0 && d4 <= 0.0) {
    return min(abs(d1), min(abs(d2), min(abs(d3), abs(d4)))) / l;
  }

  d1 = sdf_seg(st, a, b);
  d2 = sdf_seg(st, b, c);
  d3 = sdf_seg(st, c, d);
  d4 = sdf_seg(st, d, a);

  return -min(abs(d1), min(abs(d2), min(abs(d3), abs(d4)))) / l;  
}

UDF fill(in SDF d, in float start, in float end, in float smth_start, float smth_end) {
  smth_start = (end - start) * smth_start;
  smth_end = (end - start) * smth_end;
  return smoothstep(start, start + smth_start, d) - smoothstep(end - smth_end, end, d);
}

UDF fill(in SDF d, in float start, in float end, in float smth) {
  return fill(d, start, end, smth, smth);
}

UDF fill(in SDF d, in float start, in float smth) {
  return fill(d, start, 1.0, smth, 0.0);
}

UDF fill(in SDF d, in float smth) {
  return fill(d, 0.0, 1.0, smth, 0.0);
}

/**
  box2 由四个点构成矩形或平行四边形
 */
struct box2 {
  vec2 a;
  vec2 b;
  vec2 c;
  vec2 d;
};

/**
  求 box2 的中心点
 */
vec2 center(in box2 box) {
  return (box.a + box.c) * 0.5;
}

/**
  创建 box2

  参数：
    vec2 point  参考点
    vec2 size   宽高
    vec2 anchro 锚

  返回值：
    box2
 */
box2 create_box(in vec2 point, in vec2 size, in vec2 anchor) {
  vec2 a = point + size * (vec2(0.0) - anchor);
  vec2 b = point + size * (vec2(1.0, 0.0) - anchor);
  vec2 c = point + size * (vec2(1.0) - anchor);
  vec2 d = point + size * (vec2(0.0, 1.0) - anchor);

  return box2(a, b, c, d);  
}

box2 create_box(in vec2 point, in vec2 size) {
  return create_box(point, size, vec2(0.0));
}

box2 create_box(in vec2 size) {
  return create_box(vec2(0.0), size, vec2(0.0));
}

box2 create_box() {
  return create_box(vec2(0.0), vec2(1.0), vec2(0.0));
}

/**
  求一个坐标点 p 在 box 中的相对坐标值 （0 ~ 1）

  参数：
    vec2 p    坐标点
    box2 box  当前 box 对象
  
  返回值：
    vec2 单位坐标值
 */
vec2 box_quad(in vec2 p, in box2 box) {
  vec2 v1 = box.b - box.a;
  vec2 v2 = box.d - box.a;

  vec2 vp = p - box.a;

  float d1 = vp.x * v1.y - vp.y * v1.x;
  float d2 = vp.x * v2.y - vp.y * v2.x;

  if(d1 * d2 <= 0.0) {
    float l1 = length(v1);
    float l2 = length(v2);
    float p1 = (vp.x * v1.x + vp.y * v1.y) / pow(l1, 2.0);
    float p2 = (vp.x * v2.x + vp.y * v2.y) / pow(l2, 2.0);

    if(p1 >= 0.0 && p1 <= 1.0 && p2 >= 0.0 && p2 <= 1.0) {
      return vec2(p1, p2);
    }
  }

  return vec2(-1.0);
}

/**
  计算向量和 box 的 transform
 */
vec2 transform(in vec2 v0, mat3 matrix) {
  return vec2(vec3(v0, 1.0) * matrix);
}

vec2 translate(in vec2 v0, in vec2 xy) {
  mat3 m = mat3(1, 0, xy.x, 0, 1, xy.y, 0, 0, 1);
  return transform(v0, m);
}

vec2 scale(in vec2 v0, in vec2 origin, in vec2 scale) {
  mat3 m = mat3(scale.x, 0, 0, 0, scale.y, 0, 0, 0, 1);
  return transform(v0 - origin, m) + origin;
}

vec2 scale(in vec2 v0, in vec2 scaleXY) {
  return scale(v0, vec2(0.0), scaleXY);
}

vec2 rotate(in vec2 v0, in vec2 origin, float ang) {
  float sinA = sin(ang);
  float cosA = cos(ang);
  mat3 m = mat3(cosA, sinA, 0, -sinA, cosA, 0, 0, 0, 1);
  return transform(v0 - origin, m) + origin;
}

vec2 rotate(in vec2 v0, float ang) {
  return rotate(v0, vec2(0.0), ang);
}

vec2 skew(in vec2 v0, in vec2 origin, in vec2 skew) {
  mat3 m = mat3(1, tan(skew.y), 0, tan(skew.x), 1, 0, 0, 0, 1);
  return transform(v0 - origin, m) + origin;
}

vec2 skew(in vec2 v0, in vec2 skewXY) {
  return skew(v0, vec2(0.0), skewXY);
}

box2 transform(in box2 box, mat3 matrix) {
  return box2(
    transform(box.a, matrix),
    transform(box.b, matrix),
    transform(box.c, matrix),
    transform(box.d, matrix)
  );
}

box2 translate(in box2 box, in vec2 xy) {
  return box2(
    translate(box.a, xy), 
    translate(box.b, xy), 
    translate(box.c, xy), 
    translate(box.d, xy)
  );
}

box2 scale(in box2 box, in vec2 origin, in vec2 scaleXY) {
  return box2(
    scale(box.a, origin, scaleXY), 
    scale(box.b, origin, scaleXY), 
    scale(box.c, origin, scaleXY), 
    scale(box.d, origin, scaleXY)
  );
}

box2 scale(in box2 box, in vec2 scaleXY) {
  return box2(
    scale(box.a, scaleXY), 
    scale(box.b, scaleXY), 
    scale(box.c, scaleXY), 
    scale(box.d, scaleXY)
  );
}

box2 rotate(in box2 box, in vec2 origin, float ang) {
  return box2(
    rotate(box.a, origin, ang),
    rotate(box.b, origin, ang),
    rotate(box.c, origin, ang),
    rotate(box.d, origin, ang)
  );
}

box2 rotate(in box2 box, float ang) {
  return box2(
    rotate(box.a, ang),
    rotate(box.b, ang),
    rotate(box.c, ang),
    rotate(box.d, ang)
  );
}

box2 skew(in box2 box, in vec2 origin, in vec2 skewXY) {
  return box2(
    skew(box.a, origin, skewXY),
    skew(box.b, origin, skewXY),
    skew(box.c, origin, skewXY),
    skew(box.d, origin, skewXY)
  );
}

box2 skew(in box2 box, in vec2 skewXY) {
  return box2(
    skew(box.a, skewXY),
    skew(box.b, skewXY),
    skew(box.c, skewXY),
    skew(box.d, skewXY)
  );
}

/**
  将直角坐标转为极坐标
 */
vec2 polar(vec2 st, vec2 c) {
  vec2 p = c - st;
  float r = length(p) * 2.0;
  float a = atan(p.y, p.x);

  return vec2(r, a);  
}

/**
  complement(d1, d2, d3...) = complement(union(d1, d2, d3...), intersect(d1, d2, d3...))
 */

UDF udf_intersect(in UDF d1, in UDF d2) {
  if(d1 > 0.0 && d2 > 0.0) {
    return max(d1, d2);
  }
  return 0.0;
}

UDF udf_union(in UDF d1, in UDF d2) {
  if(d1 > 0.0 || d2 > 0.0) {
    return max(d1, d2);
  }
  return 0.0;
}

UDF udf_complement(in UDF d1, in UDF d2) {
  if(d1 > 0.0 && d2 > 0.0) {
    if(d1 == 1.0 && d2 < 1.0) {
      return 1.0 - d2;
    }
    if(d1 < 1.0 && d2 == 1.0) {
      return 1.0 - d1;
    }
    if(d1 < 1.0 && d2 < 1.0) {
      if(d1 > d2) {
        if(d1 < 1.0 - d2) {
          return d1;
        }
        return 1.0 - d2;
      }
      if(d2 < 1.0 - d1) {
        return d2;
      }
      return 1.0 - d1;
    }
    return 0.0;
  }
  if(d1 > 0.0) return d1;
  if(d2 > 0.0) return d2;
  return 0.0;
}

#endif