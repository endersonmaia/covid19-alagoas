package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"regexp"
	"strings"
)

const mainURL = "http://www.alagoascontraocoronavirus.al.gov.br"

func main() {
	resp, err := http.Get(mainURL)

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		panic(err)
	}

	if err := getBoletim(body); err != nil {
		panic(err)
	}

	if err := getLeitos(body); err != nil {
		panic(err)
	}

	fmt.Println("Finished")
}

func getBoletim(body []byte) error {
	var re *regexp.Regexp

	re = regexp.MustCompile(`href="(.*Informe.*.pdf)`)
	boletimURL := re.FindStringSubmatch(string(body))[1]
	btmp := strings.Split(boletimURL, "/")
	boletimFile, _ := url.QueryUnescape(btmp[len(btmp)-1])

	if _, err := os.Stat("./boletins/" + boletimFile); err == nil {
		fmt.Printf("Arquivo %q já baixado.\n", boletimFile)
		return nil
	}

	fmt.Printf("URL Boletim : %q\n", boletimURL)
	fmt.Printf("Boletim Filename : %q\n", boletimFile)

	err := downloadFile("./boletins/"+boletimFile, boletimURL)

	if err != nil {
		return err
	}

	return nil
}

func getLeitos(body []byte) error {
	var re *regexp.Regexp

	re = regexp.MustCompile(`href="(.*Ocupa.*.pdf)`)
	ocupacaoURL := re.FindStringSubmatch(string(body))[1]
	otmp := strings.Split(ocupacaoURL, "/")
	ocupacaoFile, _ := url.QueryUnescape(otmp[len(otmp)-1])

	if _, err := os.Stat("./leitos/" + ocupacaoFile); err == nil {
		fmt.Printf("Arquivo %q já baixado.\n", ocupacaoFile)
		return nil
	}

	fmt.Printf("URL Ocupação : %q\n", ocupacaoURL)
	fmt.Printf("Ocupação Filename : %q\n", ocupacaoFile)

	err := downloadFile("./leitos/"+ocupacaoFile, ocupacaoURL)

	if err != nil {
		return err
	}

	return nil
}

func downloadFile(filepath string, url string) (err error) {

	// Create the file
	out, err := os.Create(filepath)
	if err != nil {
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
	if err != nil {
		return err
	}

	return nil
}
