
# utilisation de la dernire version (docker hub)
FROM rust:1.87 as builder

# Installe Rust nightly et le définit comme version par défaut
RUN rustup install nightly && rustup default nightly

# définit le répertoire de travail dans le conteneur tous les chemins relatifs suivant 
# seront basés ici
WORKDIR /usr/src/app

# copie le contenur du projet local dans le dossier ci-dessus
COPY . .

# compile et installe l'application rust
# cargo install place le binaire compilé dans usr/local/cargo/bin/.
RUN cargo install --path .

# permet d'utiliser une image debian minimale
# pour réduire la taille finale
FROM debian:bookworm-slim

# installe les dépendances nécessaires à l'execution du binaire
RUN apt-get update && apt-get install  && rm -rf /var/lib/apt/lists/*

# copie le binaire compilé vers l'image finale
COPY --from=builder /usr/local/cargo/bin/shop_bin /usr/local/bin/shop

# définit la commande par défaut à executer quand le conteneur démarre
# shop est un binaire executable
CMD ["shop"]


