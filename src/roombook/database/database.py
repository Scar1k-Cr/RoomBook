
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).parent  # Папка проекта
SCHEMA_PATH = BASE_DIR / "schema.sql"  # Файл SQL-схемы
DB_PATH = BASE_DIR / "room_book.db"  # Файл базы данных


# Инициализация базы данных
def init_db():
    with open(SCHEMA_PATH, encoding="utf-8") as f:
        script = f.read()  # Читаем SQL-код

    conn = sqlite3.connect(DB_PATH)

    try:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.executescript(script)
        conn.commit()
    finally:
        conn.close()

    print("\n\nБаза данных создана.")


# Вывод всех таблиц при запуске этого файла
if __name__ == "__main__":
    init_db()

    for name in (
        "user_roles",
        "room_types",
        "users",
        "rooms",
        "forms",
        "reservations"
    ):
        conn = sqlite3.connect(DB_PATH)

        try:
            conn.execute("PRAGMA foreign_keys = ON")
            tables = conn.execute(
                f"SELECT * FROM {name}"
            ).fetchall()
        finally:
            conn.close()

        print(f"\n\n===== {name} =====")

        for table in tables:
            print(table)

