package core

import (
	"encoding/json"

	"github.com/UsingCoding/fpgo/pkg/slices"
	"github.com/gogo/protobuf/proto"
	corev1 "k8s.io/api/core/v1"
)

type ObjectsSlice []proto.Marshaler

func (s *ObjectsSlice) Add(v proto.Marshaler) {
	*s = append(*s, v)
}

func (s *ObjectsSlice) Objects() []interface{} {
	return slices.Map(*s, func(v proto.Marshaler) interface{} {
		return v
	})
}

func (s *ObjectsSlice) MarshalJSON() ([]byte, error) {
	var result []json.RawMessage
	for _, object := range *s {
		data, err := json.Marshal(object)
		if err != nil {
			return nil, err
		}
		result = append(result, data)
	}
	return json.Marshal(result)
}

type Namespace struct {
	corev1.Namespace
	ObjectsSlice
}

func (n *Namespace) Objects() []interface{} {
	return append(
		[]interface{}{n.Namespace},
		n.ObjectsSlice.Objects()...,
	)
}
