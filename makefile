GTEST_DIR=ngnix/googletest/googletest
GMOCK_DIR=ngnix/googletest/googlemock

all: echo_server

echo_server: main.cpp ngnix/config_parser.cc response.cpp request.cpp request_handler.cpp request_handler_echo.cpp request_handler_static.cpp \
	request_handler_default.cpp server.cpp connection.cpp 
	g++ main.cpp ngnix/config_parser.cc response.cpp request.cpp request_handler.cpp request_handler_echo.cpp request_handler_static.cpp \
	request_handler_default.cpp server.cpp connection.cpp \
	-std=c++0x -g -Wall -lboost_regex -lboost_system -lpthread -o webserver

# test: mime_types.cpp reply.cpp reply_test.cpp request_parser.cpp request_handler.cpp request_parser_test.cpp request_handler_test.cpp connection.cpp connection_test.cc ${GTEST_DIR}/src/gtest-all.cc ${GTEST_DIR}/src/gtest_main.cc ${GMOCK_DIR}/src/gmock-all.cc
# 	g++ mime_types.cpp reply.cpp reply_test.cpp request_parser.cpp request_handler.cpp request_parser_test.cpp request_handler_test.cpp connection.cpp connection_test.cc -isystem ${GTEST_DIR}/include \
# 	-I${GTEST_DIR} ${GTEST_DIR}/src/gtest-all.cc ${GTEST_DIR}/src/gtest_main.cc \
# 	-isystem ${GMOCK_DIR}/include -I${GMOCK_DIR} ${GMOCK_DIR}/src/gmock-all.cc \
# 	-std=c++0x -g -Wall -lboost_regex -lboost_system -fprofile-arcs -ftest-coverage -lpthread -o mytest
# 	./mytest
# 	gcov -r connection.cpp reply.cpp request_handler.cpp request_parser.cpp server.cpp

# gcov: server_test.cc connection_test.cc server.cpp ${GTEST_DIR}/src/gtest-all.cc connection.cpp ${GTEST_DIR}/src/gtest_main.cc ${GMOCK_DIR}/src/gmock-all.cc
# 	g++ server_test.cc connection_test.cc server.cpp -isystem ${GTEST_DIR}/include \
# 	-I${GTEST_DIR} ${GTEST_DIR}/src/gtest-all.cc connection.cpp ${GTEST_DIR}/src/gtest_main.cc \
# 	-isystem ${GMOCK_DIR}/include -I${GMOCK_DIR} ${GMOCK_DIR}/src/gmock-all.cc \
# 	-std=c++0x -g -Wall -lboost_regex -lboost_system -fprofile-arcs -ftest-coverage -lpthread -o gcov_test

# integration: integration_test.sh
# 	./integration_test.sh

clean:
	rm -rf *.o webserver