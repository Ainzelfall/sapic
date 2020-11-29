FROM node:12-alpine as build

# Create app directory
WORKDIR /app
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json yarn* ./

#RUN apt-get update
#RUN apt-get install build-essential

RUN yarn install --frozen-lockfile --production
# If you are building your code for production
# RUN npm install --only=production
COPY . .
# Remove background folder, so it wont trigger build
# RUN rm -r background didnt work

RUN yarn build

ARG CIRCLE_BUILD_NUM=30
RUN CIRCLE_BUILD_NUM=$CIRCLE_BUILD_NUM yarn build

FROM nginx:stable

COPY --from=build /app/dist /usr/share/nginx/html
