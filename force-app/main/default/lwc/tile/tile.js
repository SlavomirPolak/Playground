import { LightningElement, api } from 'lwc';

export default class Tile extends LightningElement {
    @api product;

    tileClick() {
        const event = new CustomEvent('tileclick', {
            // detail contains only primitives
            detail: this.product.CaseNumber
        });
        // Fire the event from c-tile
        this.dispatchEvent(event);
    }
}