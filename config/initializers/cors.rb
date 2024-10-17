Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://concurrency-theater-front.vercel.app',
            'http://concurrency-theater-front.vercel.app',
            'http://localhost:3000',
            'http://localhost:5173' # Vite's default port

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Authorization']
  end
end