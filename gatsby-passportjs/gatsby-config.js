
const { createProxyMiddleware } = require("http-proxy-middleware") 

module.exports = {
  siteMetadata: {
    title: "Gatsby-PassportJS",
  },
  developMiddleware: app => {
    app.use(
      "/.netlify/functions/",
      createProxyMiddleware({
        target: "http://localhost:9000",
        pathRewrite: {
          "/.netlify/functions/": "",
        },
      })
    )
  },
  plugins: [],
};
