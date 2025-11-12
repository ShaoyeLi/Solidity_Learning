{

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
    }

    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
        revert(0, 0)
    }

    function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
        revert(0, 0)
    }

    function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
        revert(0, 0)
    }

    function revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() {
        revert(0, 0)
    }

    function round_up_to_mul_of_32(value) -> result {
        result := and(add(value, 31), not(31))
    }

    function panic_error_0x41() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x41)
        revert(0, 0x24)
    }

    function finalize_allocation(memPtr, size) {
        let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
        // protect against overflow
        if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
        mstore(64, newFreePtr)
    }

    function allocate_memory(size) -> memPtr {
        memPtr := allocate_unbounded()
        finalize_allocation(memPtr, size)
    }

    function array_allocation_size_t_string_memory_ptr(length) -> size {
        // Make sure we can allocate memory without overflow
        if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

        size := round_up_to_mul_of_32(length)

        // add length slot
        size := add(size, 0x20)

    }

    function copy_calldata_to_memory_with_cleanup(src, dst, length) {
        calldatacopy(dst, src, length)
        mstore(add(dst, length), 0)
    }

    function abi_decode_available_length_t_string_memory_ptr(src, length, end) -> array {
        array := allocate_memory(array_allocation_size_t_string_memory_ptr(length))
        mstore(array, length)
        let dst := add(array, 0x20)
        if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
        copy_calldata_to_memory_with_cleanup(src, dst, length)
    }

    // string
    function abi_decode_t_string_memory_ptr(offset, end) -> array {
        if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
        let length := calldataload(offset)
        array := abi_decode_available_length_t_string_memory_ptr(add(offset, 0x20), length, end)
    }

    function abi_decode_tuple_t_string_memory_ptr(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := calldataload(add(headStart, 0))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
        }

    }

    function cleanup_t_bytes32(value) -> cleaned {
        cleaned := value
    }

    function abi_encode_t_bytes32_to_t_bytes32_fromStack(value, pos) {
        mstore(pos, cleanup_t_bytes32(value))
    }

    function abi_encode_tuple_t_bytes32__to_t_bytes32__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_bytes32_to_t_bytes32_fromStack(value0,  add(headStart, 0))

    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function validator_revert_t_address(value) {
        if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
    }

    function abi_decode_t_address(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_address(value)
    }

    function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

    }

    function abi_encode_t_address_to_t_address_fromStack(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function array_length_t_string_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function copy_memory_to_memory_with_cleanup(src, dst, length) {
        let i := 0
        for { } lt(i, length) { i := add(i, 32) }
        {
            mstore(add(dst, i), mload(add(src, i)))
        }
        mstore(add(dst, length), 0)
    }

    function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value, pos) -> end {
        let length := array_length_t_string_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length)
        copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
        end := add(pos, round_up_to_mul_of_32(length))
    }

    function cleanup_t_bool(value) -> cleaned {
        cleaned := iszero(iszero(value))
    }

    function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
        mstore(pos, cleanup_t_bool(value))
    }

    function abi_encode_tuple_t_address_t_uint256_t_string_memory_ptr_t_bool__to_t_address_t_uint256_t_string_memory_ptr_t_bool__fromStack_reversed(headStart , value3, value2, value1, value0) -> tail {
        tail := add(headStart, 128)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value2,  tail)

        abi_encode_t_bool_to_t_bool_fromStack(value3,  add(headStart, 96))

    }

    function revert_error_15abf5612cd996bc235ba1e55a4a30ac60e6bb601ff7ba4ad3f179b6be8d0490() {
        revert(0, 0)
    }

    function revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() {
        revert(0, 0)
    }

    // string
    function abi_decode_t_string_calldata_ptr(offset, end) -> arrayPos, length {
        if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
        length := calldataload(offset)
        if gt(length, 0xffffffffffffffff) { revert_error_15abf5612cd996bc235ba1e55a4a30ac60e6bb601ff7ba4ad3f179b6be8d0490() }
        arrayPos := add(offset, 0x20)
        if gt(add(arrayPos, mul(length, 0x01)), end) { revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() }
    }

    function abi_decode_tuple_t_string_calldata_ptr(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := calldataload(add(headStart, 0))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value0, value1 := abi_decode_t_string_calldata_ptr(add(headStart, offset), dataEnd)
        }

    }

    function abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value0,  tail)

    }

    function abi_encode_tuple_t_address_t_uint256_t_bool__to_t_address_t_uint256_t_bool__fromStack_reversed(headStart , value2, value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

        abi_encode_t_bool_to_t_bool_fromStack(value2,  add(headStart, 64))

    }

    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_address__to_t_address__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

    }

    function validator_revert_t_bytes32(value) {
        if iszero(eq(value, cleanup_t_bytes32(value))) { revert(0, 0) }
    }

    function abi_decode_t_bytes32(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_bytes32(value)
    }

    function abi_decode_tuple_t_bytes32t_string_calldata_ptrt_string_calldata_ptr(headStart, dataEnd) -> value0, value1, value2, value3, value4 {
        if slt(sub(dataEnd, headStart), 96) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_bytes32(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1, value2 := abi_decode_t_string_calldata_ptr(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 64))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value3, value4 := abi_decode_t_string_calldata_ptr(add(headStart, offset), dataEnd)
        }

    }

    function store_literal_in_memory_15ed5034391ed5ef65b8bb8dbcb08f9b6c4034ebcf89f76344a17e1651e92b33(memPtr) {

        mstore(add(memPtr, 0), "Caller is not the owner")

    }

    function abi_encode_t_stringliteral_15ed5034391ed5ef65b8bb8dbcb08f9b6c4034ebcf89f76344a17e1651e92b33_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 23)
        store_literal_in_memory_15ed5034391ed5ef65b8bb8dbcb08f9b6c4034ebcf89f76344a17e1651e92b33(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_15ed5034391ed5ef65b8bb8dbcb08f9b6c4034ebcf89f76344a17e1651e92b33__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_15ed5034391ed5ef65b8bb8dbcb08f9b6c4034ebcf89f76344a17e1651e92b33_to_t_string_memory_ptr_fromStack( tail)

    }

    function array_storeLengthForEncoding_t_bytes_memory_ptr_nonPadded_inplace_fromStack(pos, length) -> updated_pos {
        updated_pos := pos
    }

    function store_literal_in_memory_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470(memPtr) {

    }

    function abi_encode_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470_to_t_bytes_memory_ptr_nonPadded_inplace_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_bytes_memory_ptr_nonPadded_inplace_fromStack(pos, 0)
        store_literal_in_memory_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470(pos)
        end := add(pos, 0)
    }

    function abi_encode_tuple_packed_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470__to_t_bytes_memory_ptr__nonPadded_inplace_fromStack_reversed(pos ) -> end {

        pos := abi_encode_t_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470_to_t_bytes_memory_ptr_nonPadded_inplace_fromStack( pos)

        end := pos
    }

    function store_literal_in_memory_445140255c9d889994129d349e64078d6f76b4b37ec896948f7e858f9b8a0dcb(memPtr) {

        mstore(add(memPtr, 0), "Failed to send Ether")

    }

    function abi_encode_t_stringliteral_445140255c9d889994129d349e64078d6f76b4b37ec896948f7e858f9b8a0dcb_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
        store_literal_in_memory_445140255c9d889994129d349e64078d6f76b4b37ec896948f7e858f9b8a0dcb(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_445140255c9d889994129d349e64078d6f76b4b37ec896948f7e858f9b8a0dcb__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_445140255c9d889994129d349e64078d6f76b4b37ec896948f7e858f9b8a0dcb_to_t_string_memory_ptr_fromStack( tail)

    }

    function panic_error_0x22() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x22)
        revert(0, 0x24)
    }

    function extract_byte_array_length(data) -> length {
        length := div(data, 2)
        let outOfPlaceEncoding := and(data, 1)
        if iszero(outOfPlaceEncoding) {
            length := and(length, 0x7f)
        }

        if eq(outOfPlaceEncoding, lt(length, 32)) {
            panic_error_0x22()
        }
    }

    function array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length) -> updated_pos {
        updated_pos := pos
    }

    // string -> string
    function abi_encode_t_string_calldata_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(start, length, pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length)

        copy_calldata_to_memory_with_cleanup(start, pos, length)
        end := add(pos, length)
    }

    function abi_encode_tuple_packed_t_string_calldata_ptr__to_t_string_memory_ptr__nonPadded_inplace_fromStack_reversed(pos , value1, value0) -> end {

        pos := abi_encode_t_string_calldata_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value0, value1,  pos)

        end := pos
    }

    function store_literal_in_memory_11180b9eebea8fd225a9329819d85b39ab25bafcc6c686536ba15e29a389be15(memPtr) {

        mstore(add(memPtr, 0), "No submission found for this pas")

        mstore(add(memPtr, 32), "sword")

    }

    function abi_encode_t_stringliteral_11180b9eebea8fd225a9329819d85b39ab25bafcc6c686536ba15e29a389be15_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 37)
        store_literal_in_memory_11180b9eebea8fd225a9329819d85b39ab25bafcc6c686536ba15e29a389be15(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_11180b9eebea8fd225a9329819d85b39ab25bafcc6c686536ba15e29a389be15__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_11180b9eebea8fd225a9329819d85b39ab25bafcc6c686536ba15e29a389be15_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_44a04056f14391db4993e1d330f23c1729c9db8ea72672f993d10bf739c6e265(memPtr) {

        mstore(add(memPtr, 0), "You are not the owner of this su")

        mstore(add(memPtr, 32), "bmission")

    }

    function abi_encode_t_stringliteral_44a04056f14391db4993e1d330f23c1729c9db8ea72672f993d10bf739c6e265_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 40)
        store_literal_in_memory_44a04056f14391db4993e1d330f23c1729c9db8ea72672f993d10bf739c6e265(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_44a04056f14391db4993e1d330f23c1729c9db8ea72672f993d10bf739c6e265__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_44a04056f14391db4993e1d330f23c1729c9db8ea72672f993d10bf739c6e265_to_t_string_memory_ptr_fromStack( tail)

    }

    function panic_error_0x11() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x11)
        revert(0, 0x24)
    }

    function checked_add_t_uint256(x, y) -> sum {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        sum := add(x, y)

        if gt(x, sum) { panic_error_0x11() }

    }

    function store_literal_in_memory_bce5a93b95107dd1a720267a64c68a34fcf3d5b826d0589b95ad2719b3314bda(memPtr) {

        mstore(add(memPtr, 0), "Time lock has not expired")

    }

    function abi_encode_t_stringliteral_bce5a93b95107dd1a720267a64c68a34fcf3d5b826d0589b95ad2719b3314bda_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 25)
        store_literal_in_memory_bce5a93b95107dd1a720267a64c68a34fcf3d5b826d0589b95ad2719b3314bda(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_bce5a93b95107dd1a720267a64c68a34fcf3d5b826d0589b95ad2719b3314bda__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_bce5a93b95107dd1a720267a64c68a34fcf3d5b826d0589b95ad2719b3314bda_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_fe469041df31e4868194d9b26c541067841352ecbfaab9ddf9b1fc266600f9fe(memPtr) {

        mstore(add(memPtr, 0), "Submission has already been clai")

        mstore(add(memPtr, 32), "med")

    }

    function abi_encode_t_stringliteral_fe469041df31e4868194d9b26c541067841352ecbfaab9ddf9b1fc266600f9fe_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 35)
        store_literal_in_memory_fe469041df31e4868194d9b26c541067841352ecbfaab9ddf9b1fc266600f9fe(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_fe469041df31e4868194d9b26c541067841352ecbfaab9ddf9b1fc266600f9fe__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_fe469041df31e4868194d9b26c541067841352ecbfaab9ddf9b1fc266600f9fe_to_t_string_memory_ptr_fromStack( tail)

    }

    function array_dataslot_t_string_storage(ptr) -> data {
        data := ptr

        mstore(0, ptr)
        data := keccak256(0, 0x20)

    }

    // string -> string
    function abi_encode_t_string_storage_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value, pos) -> ret {
        let slotValue := sload(value)
        let length := extract_byte_array_length(slotValue)
        pos := array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length)
        switch and(slotValue, 1)
        case 0 {
            // short byte array
            mstore(pos, and(slotValue, not(0xff)))
            ret := add(pos, mul(length, iszero(iszero(length))))
        }
        case 1 {
            // long byte array
            let dataPos := array_dataslot_t_string_storage(value)
            let i := 0
            for { } lt(i, length) { i := add(i, 0x20) } {
                mstore(add(pos, i), sload(dataPos))
                dataPos := add(dataPos, 1)
            }
            ret := add(pos, length)
        }
    }

    function abi_encode_tuple_packed_t_string_storage__to_t_string_memory_ptr__nonPadded_inplace_fromStack_reversed(pos , value0) -> end {

        pos := abi_encode_t_string_storage_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value0,  pos)

        end := pos
    }

    function store_literal_in_memory_226c473f763ce405346be9a5b3200f64faf8ca6932e00ee6f5987b8a685456fb(memPtr) {

        mstore(add(memPtr, 0), "Incorrect deposit fee sent")

    }

    function abi_encode_t_stringliteral_226c473f763ce405346be9a5b3200f64faf8ca6932e00ee6f5987b8a685456fb_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 26)
        store_literal_in_memory_226c473f763ce405346be9a5b3200f64faf8ca6932e00ee6f5987b8a685456fb(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_226c473f763ce405346be9a5b3200f64faf8ca6932e00ee6f5987b8a685456fb__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_226c473f763ce405346be9a5b3200f64faf8ca6932e00ee6f5987b8a685456fb_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_0a561dd39804056f9cb85b243e31e4c69f88a53ccc3ae4251e4c0272f898f4cf(memPtr) {

        mstore(add(memPtr, 0), "Student ID cannot be empty")

    }

    function abi_encode_t_stringliteral_0a561dd39804056f9cb85b243e31e4c69f88a53ccc3ae4251e4c0272f898f4cf_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 26)
        store_literal_in_memory_0a561dd39804056f9cb85b243e31e4c69f88a53ccc3ae4251e4c0272f898f4cf(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_0a561dd39804056f9cb85b243e31e4c69f88a53ccc3ae4251e4c0272f898f4cf__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_0a561dd39804056f9cb85b243e31e4c69f88a53ccc3ae4251e4c0272f898f4cf_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_942e4336d713360b1e69246624338b196a1c961dc51665fc35efc77951344e57(memPtr) {

        mstore(add(memPtr, 0), "This password has already been u")

        mstore(add(memPtr, 32), "sed")

    }

    function abi_encode_t_stringliteral_942e4336d713360b1e69246624338b196a1c961dc51665fc35efc77951344e57_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 35)
        store_literal_in_memory_942e4336d713360b1e69246624338b196a1c961dc51665fc35efc77951344e57(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_942e4336d713360b1e69246624338b196a1c961dc51665fc35efc77951344e57__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_942e4336d713360b1e69246624338b196a1c961dc51665fc35efc77951344e57_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_9a5b2c09f4817bf78d029fbf56c2582be845e27e7de954fc3fe317e23f73463f(memPtr) {

        mstore(add(memPtr, 0), "This student ID has already been")

        mstore(add(memPtr, 32), " submitted")

    }

    function abi_encode_t_stringliteral_9a5b2c09f4817bf78d029fbf56c2582be845e27e7de954fc3fe317e23f73463f_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 42)
        store_literal_in_memory_9a5b2c09f4817bf78d029fbf56c2582be845e27e7de954fc3fe317e23f73463f(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_9a5b2c09f4817bf78d029fbf56c2582be845e27e7de954fc3fe317e23f73463f__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_9a5b2c09f4817bf78d029fbf56c2582be845e27e7de954fc3fe317e23f73463f_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_a645f7f5928db51671fa5a68607da3bb496e5e8f623146151a50cf2f469d4d65(memPtr) {

        mstore(add(memPtr, 0), "This address has already submitt")

        mstore(add(memPtr, 32), "ed")

    }

    function abi_encode_t_stringliteral_a645f7f5928db51671fa5a68607da3bb496e5e8f623146151a50cf2f469d4d65_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 34)
        store_literal_in_memory_a645f7f5928db51671fa5a68607da3bb496e5e8f623146151a50cf2f469d4d65(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_a645f7f5928db51671fa5a68607da3bb496e5e8f623146151a50cf2f469d4d65__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_a645f7f5928db51671fa5a68607da3bb496e5e8f623146151a50cf2f469d4d65_to_t_string_memory_ptr_fromStack( tail)

    }

    function divide_by_32_ceil(value) -> result {
        result := div(add(value, 31), 32)
    }

    function shift_left_dynamic(bits, value) -> newValue {
        newValue :=

        shl(bits, value)

    }

    function update_byte_slice_dynamic32(value, shiftBytes, toInsert) -> result {
        let shiftBits := mul(shiftBytes, 8)
        let mask := shift_left_dynamic(shiftBits, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
        toInsert := shift_left_dynamic(shiftBits, toInsert)
        value := and(value, not(mask))
        result := or(value, and(toInsert, mask))
    }

    function identity(value) -> ret {
        ret := value
    }

    function convert_t_uint256_to_t_uint256(value) -> converted {
        converted := cleanup_t_uint256(identity(cleanup_t_uint256(value)))
    }

    function prepare_store_t_uint256(value) -> ret {
        ret := value
    }

    function update_storage_value_t_uint256_to_t_uint256(slot, offset, value_0) {
        let convertedValue_0 := convert_t_uint256_to_t_uint256(value_0)
        sstore(slot, update_byte_slice_dynamic32(sload(slot), offset, prepare_store_t_uint256(convertedValue_0)))
    }

    function zero_value_for_split_t_uint256() -> ret {
        ret := 0
    }

    function storage_set_to_zero_t_uint256(slot, offset) {
        let zero_0 := zero_value_for_split_t_uint256()
        update_storage_value_t_uint256_to_t_uint256(slot, offset, zero_0)
    }

    function clear_storage_range_t_bytes1(start, end) {
        for {} lt(start, end) { start := add(start, 1) }
        {
            storage_set_to_zero_t_uint256(start, 0)
        }
    }

    function clean_up_bytearray_end_slots_t_string_storage(array, len, startIndex) {

        if gt(len, 31) {
            let dataArea := array_dataslot_t_string_storage(array)
            let deleteStart := add(dataArea, divide_by_32_ceil(startIndex))
            // If we are clearing array to be short byte array, we want to clear only data starting from array data area.
            if lt(startIndex, 32) { deleteStart := dataArea }
            clear_storage_range_t_bytes1(deleteStart, add(dataArea, divide_by_32_ceil(len)))
        }

    }

    function shift_right_unsigned_dynamic(bits, value) -> newValue {
        newValue :=

        shr(bits, value)

    }

    function mask_bytes_dynamic(data, bytes) -> result {
        let mask := not(shift_right_unsigned_dynamic(mul(8, bytes), not(0)))
        result := and(data, mask)
    }
    function extract_used_part_and_set_length_of_short_byte_array(data, len) -> used {
        // we want to save only elements that are part of the array after resizing
        // others should be set to zero
        data := mask_bytes_dynamic(data, len)
        used := or(data, mul(2, len))
    }
    function copy_byte_array_to_storage_from_t_string_memory_ptr_to_t_string_storage(slot, src) {

        let newLen := array_length_t_string_memory_ptr(src)
        // Make sure array length is sane
        if gt(newLen, 0xffffffffffffffff) { panic_error_0x41() }

        let oldLen := extract_byte_array_length(sload(slot))

        // potentially truncate data
        clean_up_bytearray_end_slots_t_string_storage(slot, oldLen, newLen)

        let srcOffset := 0

        srcOffset := 0x20

        switch gt(newLen, 31)
        case 1 {
            let loopEnd := and(newLen, not(0x1f))

            let dstPtr := array_dataslot_t_string_storage(slot)
            let i := 0
            for { } lt(i, loopEnd) { i := add(i, 0x20) } {
                sstore(dstPtr, mload(add(src, srcOffset)))
                dstPtr := add(dstPtr, 1)
                srcOffset := add(srcOffset, 32)
            }
            if lt(loopEnd, newLen) {
                let lastValue := mload(add(src, srcOffset))
                sstore(dstPtr, mask_bytes_dynamic(lastValue, and(newLen, 0x1f)))
            }
            sstore(slot, add(mul(newLen, 2), 1))
        }
        default {
            let value := 0
            if newLen {
                value := mload(add(src, srcOffset))
            }
            sstore(slot, extract_used_part_and_set_length_of_short_byte_array(value, newLen))
        }
    }

}
