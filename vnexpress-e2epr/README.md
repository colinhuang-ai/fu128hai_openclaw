# VnExpress Playwright tests

## Cài đặt

```bash
npm install
npx playwright install chromium firefox webkit
```

## Chạy test

```bash
npm test
npm run test:headed
npm run report
```

Project được cấu hình chạy visible browser (`headless: false`) trên Chromium, Firefox và WebKit. WebKit là engine gần nhất với Safari trên Windows; không thay thế hoàn toàn Safari trên macOS hoặc iOS.
