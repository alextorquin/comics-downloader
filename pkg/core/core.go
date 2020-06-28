package core

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/Girbons/comics-downloader/pkg/util"
	"github.com/mholt/archiver"
	"github.com/schollz/progressbar/v2"
	log "github.com/sirupsen/logrus"
)

// DEFAULT_MESSAGE for correctly saved file
const DEFAULT_MESSAGE = "file correctly saved"

// manga output format supported
const (
	CBR  = "cbr"
	CBZ  = "cbz"
	EPUB = "epub"
	PDF  = "pdf"
)

// Comic struct contains all the informations about a comic
type Comic struct {
	Author       string
	Name         string
	IssueNumber  string
	Source       string
	URLSource    string
	Links        []string
	Format       string
	ImagesFormat string
}

// makeEPUB create the epub file
func (comic *Comic) makeEPUB(outputFolder string) error {
	/*var err error
	var incompleto bool = false

	currentDir, err := util.CurrentDir()
	if err != nil {
		return err
	}
	// used to check if the epub cover already exists
	isCoverSet := false
	// used to add the image in the epub section
	imgTag := `<img src="%s" alt="Cover Image" />`
	// setup a new Epub instance
	e := epub.NewEpub(comic.IssueNumber)
	// set Epub title
	e.SetTitle(fmt.Sprintf("%s-%s", comic.Name, comic.IssueNumber))
	// check if the author exists for this comic
	if comic.Author != "" {
		e.SetAuthor(comic.Author)
	}

	imagesPath, err, incompleto := comic.DownloadImages(outputFolder)
	if err != nil {
		return err
	}
	defer os.RemoveAll(imagesPath)

	files, err := ioutil.ReadDir(imagesPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		// add the image to the epub will return a path
		imgpath, err := e.AddImage(fmt.Sprintf("%s/%s", imagesPath, file.Name()), "")
		if err != nil {
			log.Error(err)
		}
		// if the cover is not set we'll use the first image
		// otherwise the image will be added as a section
		if !isCoverSet {
			isCoverSet = true
			e.SetCover(imgpath, "")
		} else {
			_, err = e.AddSection(fmt.Sprintf(imgTag, imgpath), "", "", "")
			if err != nil {
				log.Error(err)
			}
		}
	}

	if err = os.Chdir(currentDir); err != nil {
		return err
	}

	// get the PathSetup where the file should be saved
	// e.g. /www.mangarock.com/comic-name/
	dir, err := util.PathSetup(outputFolder, comic.Source, comic.Name)
	if err != nil {
		return err
	}

	if err = e.Write(util.GenerateFileName(dir, comic.Name, comic.IssueNumber, comic.Format)); err != nil {
		return err
	}

	log.Info(fmt.Sprintf("%s %s", strings.ToUpper(comic.Format), DEFAULT_MESSAGE))
	return err*/
	return nil
}

// makePDF create the pdf file
func (comic *Comic) makePDF(outputFolder string) error {
	/*var err error
	var incompleto bool = false

	// setup the pdf
	pdf := gofpdf.New("P", "mm", "A4", "")

	imagesPath, err, incompleto := comic.DownloadImages(outputFolder)
	if err != nil {
		return err
	}

	defer os.RemoveAll(imagesPath)

	files, err := ioutil.ReadDir(imagesPath)
	if err != nil {
		return err
	}

	// for each link get the image to add to the pdf file
	for _, file := range files {
		// add a new PDF page
		pdf.AddPage()
		imageOptions := gofpdf.ImageOptions{ImageType: util.ImageType(comic.ImagesFormat), ReadDpi: true, AllowNegativePosition: false}
		fileName := fmt.Sprintf("%s/%s", imagesPath, file.Name())
		data, err := ioutil.ReadFile(fileName)
		if err != nil {
			return err
		}
		content := bytes.NewReader(data)
		pdf.RegisterImageOptionsReader(file.Name(), imageOptions, content)
		// set the image position on the pdf page
		pdf.Image(file.Name(), 0, 0, 210, 297, false, comic.ImagesFormat, 0, "")
	}
	// get the PathSetup where the file should be saved
	// e.g. /www.mangarock.com/comic-name/
	dir, err := util.PathSetup(outputFolder, comic.Source, comic.Name)
	if err != nil {
		return err
	}

	// Save the pdf file
	if err = pdf.OutputFileAndClose(util.GenerateFileName(dir, comic.Name, comic.IssueNumber, comic.Format)); err != nil {
		return err
	}

	log.Info(fmt.Sprintf("%s %s", strings.ToUpper(comic.Format), DEFAULT_MESSAGE))
	return err*/
	return nil
}

// makeCBRZ will create the CBR/CBZ
func (comic *Comic) makeCBRZ(outputFolder string) error {
	var filesToAdd []string
	var err error
	var failedImages []int

	// setup a new Epub instance
	archive := archiver.NewZip()

	imagesPath, err, failedImages := comic.DownloadImages(outputFolder)
	if err != nil {
		return err
	}
	defer os.RemoveAll(imagesPath)

	files, err := ioutil.ReadDir(imagesPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		filesToAdd = append(filesToAdd, fmt.Sprintf("%s/%s", imagesPath, file.Name()))
	}

	// e.g. /www.mangarock.com/comic-name/
	dir, err := util.PathSetup(outputFolder, comic.Source, comic.Name)
	if err != nil {
		return err
	}
	// the archive must be created as .zip
	// then we can change the extension to .cbr or .cbz
	var suffix string = ""
	if len(failedImages) > 0 {
		f, err := os.OpenFile(dir+"/"+comic.Name+"_failed_images.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			log.Fatal(err)
		}
		f.WriteString(fmt.Sprintf("\n\n%s-%s\n", comic.Name, comic.IssueNumber))
		if err != nil {
			// FIXME
		}
		defer f.Close()
		for i := 0; i < len(failedImages); i++ {
			f.WriteString(fmt.Sprintf("%d;", failedImages[i]))
		}
		suffix = "_INCOMPLETO"
	}
	zipArchiveName := fmt.Sprintf("%s/%s.zip", dir, comic.IssueNumber)
	newName := util.GenerateFileName(dir, comic.Name, comic.IssueNumber+suffix, comic.Format)

	if err = archive.Archive(filesToAdd, zipArchiveName); err != nil {
		return err
	}

	if err = os.Rename(zipArchiveName, newName); err != nil {
		return err
	}

	log.Info(fmt.Sprintf("%s %s", strings.ToUpper(comic.Format), DEFAULT_MESSAGE))
	return err
}

// DownloadImages will download the comic/manga images
func (comic *Comic) DownloadImages(outputFolder string) (string, error, []int) {
	var dir string
	var err error
	var failedImages []int

	dir, err = util.ImagesPathSetup(outputFolder, comic.Source, comic.Name, comic.IssueNumber)
	if err != nil {
		return dir, err, failedImages
	}

	files, err := ioutil.ReadDir(dir)
	if err != nil {
		return dir, err, failedImages
	}

	if !util.DirectoryOrFileDoesNotExist(dir) && len(files) == len(comic.Links) {
		return dir, err, failedImages
	}

	format := util.ImageType(comic.ImagesFormat)

	currentDir, err := util.CurrentDir()
	if err != nil {
		return dir, err, failedImages
	}

	// setup the progress bar
	bar := progressbar.NewOptions(len(comic.Links), progressbar.OptionSetRenderBlankState(true))

	err = os.Chdir(dir)
	if err != nil {
		return dir, err, failedImages
	}

	client := &http.Client{
		Transport: &http.Transport{
			MaxIdleConns:    11,
			IdleConnTimeout: 30 * time.Second,
		},
	}

	for i, link := range comic.Links {
		if link != "" {
			rsp, err := client.Get(link)
			if err != nil {
				return dir, err, failedImages
			}
			defer rsp.Body.Close()

			imgFile, err := os.Create(fmt.Sprintf("%04d-image.%s", i, format))
			if err != nil {
				return dir, err, failedImages
			}
			defer imgFile.Close()

			err = util.SaveImage(imgFile, rsp.Body, format)
			if err != nil {
				failedImages = append(failedImages, i)
				continue
				//return dir, err
			}
		}

		if barErr := bar.Add(1); barErr != nil {
			log.Error(barErr)
		}
	}

	err = os.Chdir(currentDir)
	if err != nil {
		return dir, err, failedImages
	}

	return dir, err, failedImages
}

// MakeComic will create the file based on the output format selected.
func (comic *Comic) MakeComic(outputFolder string) error {
	var err error

	switch comic.Format {
	case EPUB:
		err = comic.makeEPUB(outputFolder)
	case CBR, CBZ:
		err = comic.makeCBRZ(outputFolder)
	default:
		err = comic.makePDF(outputFolder)
	}

	return err
}
