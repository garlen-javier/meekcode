import { Router } from "express"
import passport from "passport"
import { Strategy } from "passport-facebook"

const router = Router()

router.use((req, _res, next) => {
  if (!passport._strategy(Strategy.name)) {
    passport.use(
      new Strategy(
        {
          clientID: "225857695679143",
          clientSecret: "78f64690ca3a5dbc3f09db052f800bcf",
          callbackURL: `http://localhost:9000/.netlify/functions/auth/facebook/callback`
        },
        async function (_accessToken, _refreshToken, profile, done) {
          console.info("load user profile", profile);
          const user = {
            id: profile.id,
            displayName: profile.displayName,
          }

          req.user = user
          return done(null, user)
        }
      )
    )
  }
  next()
})

router.get(
  "/facebook",
  passport.authenticate("facebook")
)

router.get(
  "/facebook/callback",
  passport.authenticate("facebook", { failureRedirect: "/" }),
  function callback(req, res) {
    return req.login(req.user, async function callbackLogin(loginErr) {
      if (loginErr) {
        throw loginErr
      }
      return res.redirect("http://localhost:8000/welcome/?name=" + req.user.displayName)
    })
  }
)

export default router
