package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
)

type Message struct {
	Msg string
	Tid int // target Id
	Uid int
	Key string
}

type JSONMessage struct {
	Msg string `json:"msg"`
	Tid int    `json:"tid"`
	Uid int    `json:"uid"`
}

type History struct {
	Name     string        `json:"name"`
	JMessage []JSONMessage `json:"messages"`
}

var msgMap = make(map[string][]Message) // message queue
var ntyMap = make(map[int][]string)     // new message

func show() {
	fmt.Println("------------------")
	fmt.Println("msgMap = ", msgMap)
	fmt.Println("ntyMap = ", ntyMap)
}

/* Convert JSON format to Message */
func convert(m *map[string]interface{}) (*Message, bool) {
	var msg = new(Message)

	ms, ok := (*m)["msg"].(string)
	if !ok {
		fmt.Println("ms NO")
		return nil, false
	}
	msg.Msg = ms

	tid, ok := (*m)["tid"].(float64)
	if !ok {
		fmt.Println("tid NO")
		return nil, false
	}
	msg.Tid = int(tid)

	uid, ok := (*m)["uid"].(float64)
	if !ok {
		return nil, false
	}
	msg.Uid = int(uid)

	if tid < uid {
		msg.Key = strconv.Itoa(int(msg.Tid)) + "-" + strconv.Itoa(int(msg.Uid))
	} else {
		msg.Key = strconv.Itoa(int(msg.Uid)) + "-" + strconv.Itoa(int(msg.Tid))
	}

	fmt.Println("Cast OK")
	fmt.Println("msg = ", msg)
	return msg, true
}

func toMessage(jdata *JSONMessage) (*Message, bool) {
	var msg = new(Message)
	msg.Msg = jdata.Msg
	msg.Tid = jdata.Tid
	msg.Uid = jdata.Uid
	if msg.Tid < msg.Uid {
		msg.Key = strconv.Itoa(msg.Tid) + "-" + strconv.Itoa(msg.Uid)
	} else {
		msg.Key = strconv.Itoa(msg.Uid) + "-" + strconv.Itoa(msg.Tid)
	}
	return msg, true
}

func addMsg(msg *Message) {
	var list []Message
	var nlist []string
	list, _ = msgMap[msg.Key]
	msgMap[msg.Key] = append(list, *msg)

	nlist, _ = ntyMap[msg.Tid]
	ntyMap[msg.Tid] = append(nlist, msg.Key)
}

func dumpJsonRequestHandler(w http.ResponseWriter, req *http.Request) {
	if req.Method != "POST" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if req.Header.Get("Content-Type") != "application/json" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	length, err := strconv.Atoi(req.Header.Get("Content-Length"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	body := make([]byte, length)
	length, err = req.Body.Read(body)
	if err != nil && err != io.EOF {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	jdata := new(JSONMessage)
	if err := json.Unmarshal(body[:length], jdata); err != nil {
		fmt.Println("JSON Unmarchal error:", err)
		return
	}
	fmt.Println("jdata : ", jdata)
	msg, ok := toMessage(jdata)
	if !ok {
	}
	addMsg(msg)
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OKOK"))
}

func checkMessage(uid int) ([]string, bool) {
	keys, error := ntyMap[uid]
	if !error {
		return keys, false
	}
	delete(ntyMap, uid)
	return keys, true
}

func checkHandler(w http.ResponseWriter, req *http.Request) {
	id := req.FormValue("id")
	fmt.Println("id = ", id)
	i, _ := strconv.Atoi(id)
	msgs, error := checkMessage(i)
	if !error {
	}
	fmt.Println("msgs = ", msgs)
	fmt.Println("msg len = ", len(msgs))
	show()

	if len(msgs) > 0 {
		list := msgMap[msgs[0]]
		jretData := make([]JSONMessage, len(list))
		for i, m := range list {
			jretData[i] = JSONMessage{Msg: m.Msg, Tid: m.Tid, Uid: m.Uid}
		}
		fmt.Println("jretdata =", jretData)

		history := History{
			Name:     "Test",
			JMessage: jretData,
		}
		jsonByte, _ := json.Marshal(history)
		out := new(bytes.Buffer)
		json.Indent(out, jsonByte, "", "    ")
		fmt.Println(out.String())

		w.WriteHeader(200)
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		w.Write(jsonByte)
	}
}

func main() {
	fmt.Println("hoge")
	http.HandleFunc("/json", dumpJsonRequestHandler)
	http.HandleFunc("/id", checkHandler)
	http.ListenAndServe(":8080", nil)

}
