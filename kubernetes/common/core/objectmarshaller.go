package core

type Slicer interface {
	Objects() []interface{} // Any type that can be marshalled to JSON
}

type Encoder interface {
	Encode(v interface{}) error
}

func NewInlineMarshaller(encoder Encoder) *InlineMarshaller {
	return &InlineMarshaller{encoder: encoder}
}

type InlineMarshaller struct {
	encoder Encoder
}

func (m InlineMarshaller) Marshall(slicer Slicer) error {
	var result []interface{}
	m.proceed(&result, slicer)
	return m.encoder.Encode(result)
}

func (m InlineMarshaller) proceed(slice *[]interface{}, slicer Slicer) {
	for _, object := range slicer.Objects() {
		s, ok := object.(Slicer)
		if ok {
			m.proceed(slice, s)
		}
		*slice = append(*slice, object)
	}
}
