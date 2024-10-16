export function getTemplateBlueBadge(channelName: string, linkProfile: string) {
  return `
    <!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chúc mừng đạt 10.000 Follow!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .header {
            background-color: #4CAF50;
            color: white;
            text-align: center;
            padding: 10px;
            border-radius: 8px 8px 0 0;
        }

        .content {
            text-align: center;
            margin: 20px 0;
        }

        .content h1 {
            color: #333333;
        }

        .content p {
            font-size: 16px;
            color: #666666;
        }

        .cta-button {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
        }

        .cta-button:hover {
            background-color: #45a049;
        }

        .footer {
            text-align: center;
            padding: 20px;
            font-size: 12px;
            color: #999999;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <h2>Chúc Mừng  ${channelName}!</h2>
        </div>
        <div class="content">
            <h1>Bạn đã đạt 10.000 Follow!</h1>
            <p>Chúng tôi rất vui mừng thông báo rằng bạn đã đạt cột mốc quan trọng - 10.000 người theo dõi trên nền tảng
                của chúng tôi!</p>
            <p>Cảm ơn bạn đã luôn cống hiến và chia sẻ những nội dung tuyệt vời. Thành quả này là minh chứng cho sự nỗ
                lực không ngừng nghỉ của bạn!</p>
            <a href="${linkProfile}" class="cta-button">Khám phá thêm</a>
        </div>
        <div class="footer">
            <p>&copy; 2024 Nền tảng của bạn. Mọi quyền được bảo lưu.</p>
        </div>
    </div>
</body>

</html>
    `;
}
