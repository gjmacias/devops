#!/usr/bin/env python3

import os
import logging

from pathlib import Path
from datetime import datetime


# ----------------------------
# Variables Globales
# ----------------------------
project_name = "test_project"

name_dir_logs = "logs"  # nombre de la carpeta de logs
dir_logs = Path(name_dir_logs)  # mejor usar Path
dir_logs.mkdir(exist_ok=True)  # crea la carpeta si no existe

timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
log_filename = f"{name_dir_logs}/{timestamp}_{project_name}.log"

# ----------------------------
# Configuración del log
# ----------------------------
logging.basicConfig(
    filename=log_filename,        # Archivo donde se guarda el log
    level=logging.INFO,              
    format="%(asctime)s - %(levelname)s - %(message)s",
)

# ----------------------------
# Guardar log y escribir Print
# ----------------------------
def log_and_print(message, level="info"):
    print(message)

    if level == "info":
        logging.info(message)
    elif level == "warning":
        logging.warning(message)
    elif level == "error":
        logging.error(message)
    elif level == "critical":
        logging.critical(message)



# ----------------------------
# Generar Archivos y Directorios
# ----------------------------
def create_project_structure(project_name):
    logging.info(f"Generando Archivos y Directorios:")

    # Estructura de directorios
    directories = [
        project_name,
        os.path.join(project_name, "data"),
        os.path.join(project_name, "data", "raw"),
        os.path.join(project_name, "data", "processed"),
        os.path.join(project_name, "scripts"),
        os.path.join(project_name, "scripts", "one.sh"),
        os.path.join(project_name, "scripts", "two.sh"),
        os.path.join(project_name, "scripts", "three.sh"),
        os.path.join(project_name, "docs"),
        os.path.join(project_name, "docs", "one.txt"),
        os.path.join(project_name, "docs", "two.txt"),
        os.path.join(project_name, "docs", "three.txt"),
    ]

    # Crear directorios
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        logging.info(f"Creado: {directory}")
    
    log_and_print("Genearción de archivos y directorios finalizada correctamente.", level="info")


# ----------------------------
# Buscar Archivo por extension
# ----------------------------
def buscar_archivos(directorio, extension):
    try:
        ruta = Path(directorio)

        if not ruta.exists():
            log_and_print(f"El directorio '{directorio}' no existe.", level="error")
            return
        
        log_and_print(f"Iniciando búsqueda de archivos {extension} en {directorio}", level="info")
        archivos = list(ruta.rglob(f"*{extension}"))

        if not archivos:
            log_and_print(f"No se encontraron archivos con extensión {extension}", level="warning")
            return

        for archivo in archivos:
            try:
                info = archivo.stat()
                tamaño = info.st_size
                fecha_mod = datetime.fromtimestamp(info.st_mtime)
                log_and_print(f"Archivo: {archivo} | Tamaño: {tamaño} bytes | Modificado: {fecha_mod}", level="info")

            except Exception as e:
                log_and_print(f"Error al procesar el archivo {archivo}: {e}", level="error")

        log_and_print("Búsqueda finalizada correctamente.", level="info")

    except Exception as e:
        log_and_print(f"Error general en la ejecución: {e}", level="critical")


# ----------------------------
# Buscar Archivo en Loop
# ----------------------------
def loop_buscar_archivos():
    log_and_print("Modo interactivo iniciado. Escribe 'exit' para salir.", level="info")

    while True:
        try:
            directorio = input("\nIngrese el directorio: ").strip()
            if directorio.lower() == "exit":
                break

            extension = input("Ingrese la extensión (ej: .txt): ").strip()
            if extension.lower() == "exit":
                break

            buscar_archivos(directorio, extension)

        except KeyboardInterrupt:
            print("\nSaliendo del programa...")
            logging.info("Programa finalizado por el usuario (Ctrl+C)")
            break

    log_and_print("Programa finalizado.", level="info")


def main():
    create_project_structure(project_name)
    loop_buscar_archivos()


if __name__ == "__main__":
    main()