package maybe

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMaybe(t *testing.T) {
	var v Maybe[int]

	assert.False(t, Valid(v))

	v = NewJust(4)
	assert.True(t, Valid(v))
	assert.Equal(t, 4, Just(v))

	none := NewNone[int]()

	assert.False(t, Valid(none))
}
