# Node.js LTS sürümünü temel alarak bir base image seçin
FROM node:lts

# Çalışma dizini oluşturun
WORKDIR /app

# package.json ve package-lock.json dosyalarını kopyalayın
COPY package*.json ./

# Bağımlılıkları yükleyin
RUN npm ci

# Uygulama kodlarını kopyalayın
COPY . .

# React uygulamasını inşa edin
RUN npm run build

# Nginx web sunucusunu kullanarak statik dosyaları serve etmek için
# ikinci bir base image seçin
FROM nginx:stable-alpine

# React uygulamasının inşa edilmiş dosyalarını Nginx konteynerine kopyalayın
COPY --from=0 /app/build /usr/share/nginx/html

# Nginx için varsayılan portu açın
EXPOSE 80

# Nginx'i başlatın
CMD ["nginx", "-g", "daemon off;"]
