require 'sinatra'
require 'sinatra/reloader' if development?

youtube_enabled = true
internet_enabled = true

post "/internet-enable" do
  `./internet-on`
  internet_enabled = true
  redirect "/"
end

post "/internet-disable" do
  `./internet-off`
  internet_enabled = false
  redirect "/"
end

post "/enable" do
  `./firewall-off`
  youtube_enabled = true
  redirect "/"
end

post "/disable" do
  `./firewall-on`
  youtube_enabled = false
  redirect "/"
end

get "/" do
  erb(<<~HTML, locals: { youtube_enabled: youtube_enabled, internet_enabled: internet_enabled })
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
        <% if internet_enabled %>
        <form action="/internet-disable" method="post">
        <input class="on" type="submit" value="Internet Off">
        </form>
        <% if youtube_enabled %>
        <form action="/disable" method="post">
        <input class="off" type="submit" value="YouTube Off">
        </form>
        <% else %>
        <form action="/enable" method="post">
        <input class="on" type="submit" value="YouTube On">
        </form>
        <% end %>
        <% else %>
        <form action="/internet-enable" method="post">
        <input class="on" type="submit" value="Internet On">
        </form>
        <% end %>
      </div>
    </body>
  </html>
  HTML
end
