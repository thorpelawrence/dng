package flagtype

import (
	"fmt"
	"strings"
)

type oneOf struct {
	allowed []string
	value   string
}

func NewOneOf(defaultVal string, allowed []string) *oneOf {
	return &oneOf{allowed: allowed, value: defaultVal}
}

func (e *oneOf) String() string {
	return e.value
}

func (e *oneOf) Type() string {
	return "string"
}

func (e *oneOf) Set(value string) error {
	isAllowed := false

	for _, a := range e.allowed {
		if value == a {
			isAllowed = true
			break
		}
	}

	if !isAllowed {
		return fmt.Errorf("possible values: [%s]", strings.Join(e.allowed, ", "))
	}

	e.value = value
	return nil
}
