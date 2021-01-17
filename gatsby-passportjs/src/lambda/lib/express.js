import express from "express";
import sessions from "client-sessions";
import passport from "passport";
import cookieParser from "cookie-parser";
import facebook from "./strategies/facebook";

const app = express();

app.use(cookieParser());
app.use(
  sessions({
    cookieName: "session",
    secret: "YOUR SESSION SECRET",
    cookie: {
      ephemeral: false,
      secure: false 
    }
  })
);
app.use(passport.initialize());
app.use(passport.session());

passport.serializeUser((user, cb) => cb(user ? null : "null user", user));
passport.deserializeUser((user, cb) => cb(user ? null : "null user", user));

app.use("/.netlify/functions/auth", facebook);

export default app;