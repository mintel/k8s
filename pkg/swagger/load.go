package swagger

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type Loader interface {
	Load([]byte) (Definitions, error)
}

func Load(loader Loader, url string) (Definitions, error) {
	var data []byte
	if strings.HasPrefix(url, "file://") {
		path := strings.TrimPrefix(url, "file://")
		var err error
		path, err = filepath.Abs(path)
		if err != nil {
			cwd, _ := os.Getwd()
			fmt.Print(cwd)
			return nil, err
		}
		data, err = os.ReadFile(path)
		if err != nil {
			return nil, err
		}
	} else {
		r, err := http.Get(url)
		if err != nil {
			return nil, err
		}

		data, err = ioutil.ReadAll(r.Body)
		if err != nil {
			return nil, err
		}
	}

	return loader.Load(data)
}
