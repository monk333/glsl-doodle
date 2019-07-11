export default {
  // files: './doc-src/**/*.{md,markdown,mdx}',
  src: './doc-src',
  indexHtml: './doc-src/index.html',
  theme: 'docz-theme-yuque',
  public: 'doc-src/public',
  menu: [
    '简介',
    {
      name: '快速入门',
      menu: [
        '基本用法',
        '高级用法',
      ],
    },
    {
      name: '详细文档',
      menu: [
        '介绍',
        '内建属性',
        '坐标系',
        '基础图形',
        '高级图形',
        '颜色',
        '网格图案',
        '随机',
        '噪声',
        '动画',
        '事件',
      ],
    },
  ],
};