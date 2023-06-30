FROM postgres:11

RUN rm -f /var/lib/postgresql/data/pg_hba.conf
COPY pg_hba.conf /var/lib/postgresql/data/
EXPOSE 5432