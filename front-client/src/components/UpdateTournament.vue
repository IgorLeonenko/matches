<template>
  <div>
    <h1>Edit tournament</h1>
    <tournament-form :button-text="buttonText"
                     :tournament="tournament">
    </tournament-form>
  </div>
</template>

<script>
import TournamentForm from './TournamentForm'
export default {
  name: 'UpdateTournament',
  props: {
    tournament: {
      type: Object
    }
  },
  data () {
    return {
      buttonText: 'Edit'
    }
  },
  components: {
    TournamentForm
  }
}
</script>
