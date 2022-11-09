package main

import (
	"log"
	"os/exec"
	"sync"
)

type Deployer interface {
	Deploy() error
}

type deployerImpl struct {
	Deployer
}

func NewDeployer() Deployer {
	return &deployerImpl{}
}

func (d *deployerImpl) Deploy() error {
	d.downloadResources()
	d.restartCompose()
	return nil
}

func (d *deployerImpl) executeCmd(command string, args ...string) error {
	c := exec.Command(command, args...)
	c.Stdout = NewLogWriter(log.Default())
	c.Stderr = NewLogWriter(log.Default())

	if err := c.Start(); err != nil {
		return err
	}

	if err := c.Wait(); err != nil {
		return err
	}

	return nil
}

func (d *deployerImpl) downloadResources() {
	resources := map[string]string{
		"docker-compose.yaml": "https://raw.githubusercontent.com/PokimaneSafety/minecraft-server/main/docker-compose.yaml",
		"nginx.conf":          "https://raw.githubusercontent.com/PokimaneSafety/minecraft-server/main/nginx.conf",
	}

	wg := &sync.WaitGroup{}
	wg.Add(len(resources))

	for fileName, url := range resources {
		go func(fileName, url string) {
			defer wg.Done()
			if err := d.executeCmd("wget", "-O", fileName, url); err != nil {
				log.Printf("error downloading file %s: %v", fileName, err)
			}
		}(fileName, url)
	}

	wg.Wait()
}

func (d *deployerImpl) restartCompose() {
	if err := d.executeCmd("docker-compose", "down"); err != nil {
		log.Printf("error taking compose down: %v", err)
	}
	if err := d.executeCmd("docker-compose", "up", "-d"); err != nil {
		log.Printf("error bringing compose up: %v", err)
	}
}
