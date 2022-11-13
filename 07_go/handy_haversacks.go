package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func getLines(path string) []string {
	bytesRead, err := os.ReadFile(path)
	check(err)
	return strings.Split(string(bytesRead), "\n")
}

type Color = string

type BagContent struct {
	color Color
	count int
}

type Bag struct {
	color   Color
	content []BagContent
}

func parseBag(str string) Bag {
	bagPattern := regexp.MustCompile("(?P<color>^\\w+ \\w+) bags contain (?P<contentStrs>.*)\\.$")
	contentPattern := regexp.MustCompile("(?:(?P<count>\\d+) (?P<color>\\w+ \\w+) bags?)|(?P<empty>no other bags)")

	colorIndex := bagPattern.SubexpIndex("color")
	contentIndex := bagPattern.SubexpIndex("contentStrs")
	subbagColorIndex := contentPattern.SubexpIndex("color")
	subbagCountIndex := contentPattern.SubexpIndex("count")

	matches := bagPattern.FindStringSubmatch(str)

	color := matches[colorIndex]
	contentStrs := strings.Split(matches[contentIndex], ", ")

	var content []BagContent

	for _, subbagStr := range contentStrs {
		matches := contentPattern.FindStringSubmatch(subbagStr)
		subbagCount, _ := strconv.Atoi(matches[subbagCountIndex])
		subbagColor := matches[subbagColorIndex]
		content = append(content, BagContent{subbagColor, subbagCount})
	}

	return Bag{color, content}
}

func helper(graph map[Color][]BagContent, node Color, end Color, seen map[Color]bool) bool {
	for _, n := range graph[node] {
		_, ok := seen[n.color]
		if ok {
			continue
		}
		if n.color == end || helper(graph, n.color, end, seen) {
			return true
		}
		seen[n.color] = true
	}
	return false
}

func doesPathExist(graph map[Color][]BagContent, start Color, end Color) bool {
	seen := map[Color]bool{}
	return helper(graph, start, end, seen)
}

func graphSizeFrom(graph map[Color][]BagContent, start Color) int {
	result := 1
	for _, n := range graph[start] {
		result += n.count * graphSizeFrom(graph, n.color)
	}
	return result
}

func main() {
	lines := getLines("./input.txt")

	var graph map[string][]BagContent
	graph = make(map[string][]BagContent)

	for _, line := range lines {
		bag := parseBag(line)
		graph[bag.color] = bag.content
	}

	count := 0
	for bag := range graph {
		if doesPathExist(graph, bag, "shiny gold") {
			count++
		}
	}
	fmt.Println(count)
	fmt.Println(graphSizeFrom(graph, "shiny gold") - 1)
}
