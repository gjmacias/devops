from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configuración de la base de datos
db_uri = 'mysql://root:film123@database:3306/movies'
app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


def get_movies():
    """
    Recupera todas las películas de la base de datos.
    """
    movies = []
    result = db.engine.execute("SELECT name, rating FROM movies")
    for row in result:
        movies.append({"name": row[0], "rating": row[1]})
    return movies


def render_movie_li(movies):
    """
    Crea una lista HTML (<li>) con las películas.
    """
    html = ""
    for movie in movies:
        html += f"""
        <li class="list-group-item">
            <span class="badge">{movie['rating']}</span>
            {movie['name']}
        </li>
        """
    return html


@app.route('/')
def index():
    """
    Método llamado al abrir la webapp.
    """
    movies = get_movies()
    movies_li = render_movie_li(movies)

    # Leemos el HTML y colocamos la lista de películas
    with open('index.html', 'r', encoding='utf-8') as f:
        html_template = f.read()

    return html_template % movies_li


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)