require 'sinatra'
require 'sinatra/reloader' if development?

post "/enable" do
  `./firewall-off`
  redirect "/"
end

post "/disable" do
  `./firewall-on`
  redirect "/"
end

get "/" do
  <<~HTML
  <html>
    <head>
      <style>
        #content {
          margin: auto;
          max-width: 300px;
        }
        input {
          width: 200px;
          height: 80px;
        }
      </style>
    </head>
    <body>
      <div id="content">
        <form action="/enable" method="post">
        <input type="submit" value="YouTube On">
        </form>

        <form action="/disable" method="post">
        <input type="submit" value="YouTube Off">
        </form>
      </div>
    </body>
  </html>
  HTML
end
