FROM node:slim
ENV NODE_ENV development
WORKDIR /express-docker
COPY . .
RUN npm install
EXPOSE 3000
CMD [ "node", "index.js" ]