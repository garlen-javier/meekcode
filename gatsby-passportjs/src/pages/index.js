import React from "react";

const pageStyles = {
  color: "#232129",
  padding: "96px",
  fontFamily: "-apple-system, Roboto, sans-serif, serif",
};
const headingStyles = {
  marginTop: 0,
  marginBottom: 64,
  maxWidth: 320,
};

class IndexPage extends React.Component {
  constructor(props) {
    super(props);
    this.onPop = this.onPop.bind(this)
  }

  onPop = (e, loginType) => {
    var url = `http://localhost:9000/.netlify/functions/auth/${loginType}`;
    var win = typeof window !== `undefined` ? window : null;

    var n = win.open(url, "_self");
    if (n == null) {
      return true;
    }
    return false;
  };

  render() {
    return (
      <main style={pageStyles}>
        <title>Gatsby & PassportJS Tutorial</title>
        <h1 style={headingStyles}>Gatsby & PassportJS Tutorial</h1>
        <button
          type="button"
          target="_self"
          rel="noreferrer"
          onClick={e => this.onPop(e, "facebook")}
        >
          Login with Facebook!
        </button>
      </main>
    );
  }
}

export default IndexPage;
