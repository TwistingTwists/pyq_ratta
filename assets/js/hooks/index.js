import live_select from "./live_select"
import TrixEditor from './trix_editor'
import Trix from '../../vendor/trix'
import FlashyHooks from "flashy"

export default {
    TrixEditor,
    Trix,
    ...FlashyHooks,
    ...live_select
}