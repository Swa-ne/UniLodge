import { Router } from "express"


import { signupUserController } from "../controllers/signup.controller"

const router = Router()

router.post("/signup", signupUserController)

export default router