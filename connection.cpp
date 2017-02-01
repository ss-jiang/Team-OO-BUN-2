#include "connection.hpp"
#include <utility>
#include <vector>
#include <iostream> 

namespace http {
namespace server {

connection::connection(boost::asio::ip::tcp::socket socket)
  : socket_(std::move(socket))
{
}

void connection::start()
{
  do_read();
}

void connection::stop()
{
  socket_.close();
}

int connection::getServerStatus()
{
  return serverStatus; 
}

void connection::do_read()
{
  auto self(shared_from_this());
  socket_.async_read_some(boost::asio::buffer(buffer_),
      [this, self](boost::system::error_code ec, std::size_t bytes_transferred)
      {
        if (!ec)
        {
          // Appends the bytes read by async_read_some to the 'reply_' string
          reply_.append(buffer_.data(), bytes_transferred);
          if (reply_.substr(reply_.size() - 4, 4) == "\r\n\r\n")
          {
            // HTTP response and content type
            // Send back a 200 (OK) code and plain text type
            const char* response_string = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n";

            // We will be using 'response' to hold the request data from the user
            std::string response;
            response.append(reply_);

            // Cast the string into a char* as boost::asio::write requires a char*
            // and the length of what char* points to (we use strlen for this)
            const char* reply_body = response.c_str();
            
            write_response(response_string, reply_body); 
          }
          else
          {
            serverStatus = -1; 
            stop(); 
          }
        }
      });
}

void connection::write_response(const char* response, const char* reply)
{
  boost::asio::write(socket_, boost::asio::buffer(response, strlen(response)));
  boost::asio::write(socket_, boost::asio::buffer(reply, strlen(reply)));
  serverStatus = 1; // success
}

} // namespace server
} // namespace http