package main

import (
	"net/http"
	"net/url"
	"io/ioutil"
	"fmt"
	 "regexp"
	 "io"
	 "os"
	 "strings"
)

const mainURL = "http://www.alagoascontraocoronavirus.al.gov.br"

func main() {
    resp, err := http.Get(mainURL)
    if err != nil {
        print(err)
    }
    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        print(err)
	}

	var re *regexp.Regexp

	re = regexp.MustCompile(`href="(.*Informe.*.pdf)`)
	boletimURL := re.FindStringSubmatch(string(body))[1]
	btmp := strings.Split(boletimURL, "/")
	boletimFile, _ := url.QueryUnescape(btmp[len(btmp)-1])
	fmt.Printf("URL Boletim : %q\n", boletimURL)
	fmt.Printf("Boletim Filename : %q\n", boletimFile)
	downloadFile("./boletins/" + boletimFile, boletimURL)

	re = regexp.MustCompile(`href="(.*Ocupa.*.pdf)`)
	ocupacaoURL := re.FindStringSubmatch(string(body))[1]
	otmp := strings.Split(ocupacaoURL, "/")
	ocupacaoFile, _ := url.QueryUnescape(otmp[len(otmp)-1])
	fmt.Printf("URL Ocupação : %q\n", ocupacaoURL)
	fmt.Printf("Ocupação Filename : %q\n", ocupacaoFile)
	downloadFile("./leitos/" + ocupacaoFile, ocupacaoURL)

	fmt.Println("Finished")
}

func downloadFile(filepath string, url string) (err error) {

	// Create the file
	out, err := os.Create(filepath)
	if err != nil  {
	  return err
	}
	defer out.Close()
  
	// Get the data
	resp, err := http.Get(url)
	if err != nil {
	  return err
	}
	defer resp.Body.Close()
  
	// Check server response
	if resp.StatusCode != http.StatusOK {
	  return fmt.Errorf("bad status: %s", resp.Status)
	}
  
	// Writer the body to file
	_, err = io.Copy(out, resp.Body)
	if err != nil  {
	  return err
	}
  
	return nil
}