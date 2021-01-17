import React from "react"
const qs = require("query-string")

const Welcome = ({ location }) => {
  const parsed = qs.parse(location.search)

  return <div><h1>{`WELCOME!! ` + parsed.name}</h1></div>
}

export default Welcome
