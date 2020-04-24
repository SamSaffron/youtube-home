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
          max-width: 400px;
        }
        input {
          width: 400px;
          height: 150px;
          font-size: 35px;
          margin-bottom: 100px;
          margin-top: 100px;
        }
      </style>
    </head>
    <body>
      <div id="content">
        <form action="/enable" method="post">
        <input class="on" type="submit" value="YouTube On">
        </form>

        <form action="/disable" method="post">
        <input class="off" type="submit" value="YouTube Off">
        </form>
      </div>
    </body>
  </html>
  HTML
end
