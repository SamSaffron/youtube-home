require 'sinatra'
require 'sinatra/reloader' if development?

YOUTUBE_OFF_HOUR = 6
YOUTUBE_ON_HOUR = 11

class State
  class << self
    attr_accessor :internet_enabled, :enable_schedule, :youtube_enabled
  end
end

State.enable_schedule = true
State.youtube_enabled = true
State.internet_enabled = true

def youtube_on
  puts "yt on"
  if !State.youtube_enabled
    `./firewall-off`
    State.youtube_enabled = true
  end
end

def youtube_off
  puts "yt off"
  if State.youtube_enabled
    `./firewall-on`
    State.youtube_enabled = false
  end
end

Thread.new do
  while true
    sleep 1

    hour = Time.new.hour

    if State.youtube_enabled && State.enable_schedule && hour == YOUTUBE_OFF_HOUR
      youtube_off
    end
    if hour == YOUTUBE_ON_HOUR && !State.youtube_enabled && State.enable_schedule
      youtube_on
    end

    if hour == (YOUTUBE_ON_HOUR + 1)
      State.enable_schedule = true
    end
  end
end

post "/internet-enable" do
  `./internet-on`
  State.internet_enabled = true
  redirect "/"
end

post "/internet-disable" do
  `./internet-off`
  State.internet_enabled = false
  redirect "/"
end

post "/enable" do
  youtube_on
  if Time.new.hour == YOUTUBE_OFF_HOUR
    State.enable_schedule = false
  end
  redirect "/"
end

post "/disable" do
  if Time.new.hour == YOUTUBE_ON_HOUR
    State.enable_schedule = false
  end
  youtube_off
  redirect "/"
end

get "/" do
  # spinner from https://loading.io/css/
  erb(<<~HTML, locals: { youtube_enabled: State.youtube_enabled, internet_enabled: State.internet_enabled })
  <!DOCTYPE html>
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

        #content.loader-visible .lds-spinner {
          display: inherit;
        }

        #content.forms-hidden form {
          display: none;
        }

        .lds-spinner {
          color: official;
          display: inline-block;
          position: fixed;
          left: 40%;
          top: 40%;
          width: 80px;
          height: 80px;
          display: none;
        }
        .lds-spinner div {
          transform-origin: 40px 40px;
          animation: lds-spinner 1.2s linear infinite;
        }
        .lds-spinner div:after {
          content: " ";
          display: block;
          position: absolute;
          top: 3px;
          left: 37px;
          width: 6px;
          height: 18px;
          border-radius: 20%;
          background: #000000;
        }
        .lds-spinner div:nth-child(1) {
          transform: rotate(0deg);
          animation-delay: -1.1s;
        }
        .lds-spinner div:nth-child(2) {
          transform: rotate(30deg);
          animation-delay: -1s;
        }
        .lds-spinner div:nth-child(3) {
          transform: rotate(60deg);
          animation-delay: -0.9s;
        }
        .lds-spinner div:nth-child(4) {
          transform: rotate(90deg);
          animation-delay: -0.8s;
        }
        .lds-spinner div:nth-child(5) {
          transform: rotate(120deg);
          animation-delay: -0.7s;
        }
        .lds-spinner div:nth-child(6) {
          transform: rotate(150deg);
          animation-delay: -0.6s;
        }
        .lds-spinner div:nth-child(7) {
          transform: rotate(180deg);
          animation-delay: -0.5s;
        }
        .lds-spinner div:nth-child(8) {
          transform: rotate(210deg);
          animation-delay: -0.4s;
        }
        .lds-spinner div:nth-child(9) {
          transform: rotate(240deg);
          animation-delay: -0.3s;
        }
        .lds-spinner div:nth-child(10) {
          transform: rotate(270deg);
          animation-delay: -0.2s;
        }
        .lds-spinner div:nth-child(11) {
          transform: rotate(300deg);
          animation-delay: -0.1s;
        }
        .lds-spinner div:nth-child(12) {
          transform: rotate(330deg);
          animation-delay: 0s;
        }
        @keyframes lds-spinner {
          0% {
            opacity: 1;
          }
          100% {
            opacity: 0;
          }
        }
      </style>
      <script>
      function showProgress() {
        var classList = document.getElementById("content").classList;
        classList.add("forms-hidden");
        classList.add("loader-visible");

        return true;
      }
      </script>
    </head>
    <body>
      <div id="content">
        <div class="lds-spinner" id="loader"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
        <% if internet_enabled %>
        <form action="/internet-disable" method="post" onsubmit="return showProgress()">
        <input class="on" type="submit" value="Internet Off">
        </form>
        <% if youtube_enabled %>
        <form action="/disable" method="post" onsubmit="return showProgress()">
        <input class="off" type="submit" value="YouTube Off">
        </form>
        <% else %>
        <form action="/enable" method="post" onsubmit="return showProgress()">
        <input class="on" type="submit" value="YouTube On">
        </form>
        <% end %>
        <% else %>
        <form action="/internet-enable" method="post" onsubmit="return showProgress()">
        <input class="on" type="submit" value="Internet On">
        </form>
        <% end %>
      </div>
    </body>
  </html>
  HTML
end
