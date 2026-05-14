import smtplib
from email.message import EmailMessage
import logging
import os

from dotenv import load_dotenv
load_dotenv()

logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

def send_email(
    recipient="robert.marik@mendelu.cz",
    subject="Update projektu",
    content="Ahoj, posílám další info z Python skriptu!",
):
    """
    Funkce pro odeslání emailu pomocí SMTP serveru Gmail.
    Ujistěte se, že máte nastavené heslo aplikace pro tento účet.
    Heslo aplikace nastavte pomocí proměnné APP_PASSWORD,
    kterou získáte v nastavení svého Google účtu.

    Umístěte toto heslo do proměnné prostředí před spuštěním skriptu, například:
    export APP_PASSWORD="vaše_heslo_aplikace"

    """
    SENDER_EMAIL = "math.projects.cz@gmail.com"
    APP_PASSWORD = os.getenv("APP_PASSWORD")

    msg = EmailMessage()
    msg.set_content(content)
    msg["Subject"] = subject
    msg["From"] = SENDER_EMAIL
    msg["To"] = recipient

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(SENDER_EMAIL, APP_PASSWORD)
            server.send_message(msg)
        logger.info("Email byl úspěšně odeslán!")
        return True
    except Exception as e:
        logger.error(f"Chyba: {e}")
        return False


if __name__ == "__main__":
    send_email()
