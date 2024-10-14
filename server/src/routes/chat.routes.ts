import { Router } from "express"
import { createPrivateInboxController, getAllActiveUsersController, getChatMessagesController, getInboxController, getInboxDetailsController, getMessagesController, getUserDetailsController, saveMessageController } from "../controllers/chat.controller"
import { authenticateToken } from "../middlewares/token.authentication"


const router = Router()

router.get("/open", getChatMessagesController)
router.post("/create_private_inbox", authenticateToken, createPrivateInboxController)
router.get("/get_inbox_details/:chat_id", authenticateToken, getInboxDetailsController)
router.post("/save_message", authenticateToken, saveMessageController)
router.get("/get_messages/:chat_id/:page", authenticateToken, getMessagesController)
router.get("/get_user_details/:chat_id", authenticateToken, getUserDetailsController)
router.get("/get_activesers", authenticateToken, getAllActiveUsersController)
router.get("/get_inbox", authenticateToken, getInboxController)

export default router