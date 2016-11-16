<template>
  <div>
    <h1>New tournament</h1>
    <tournament-form :button-text='buttonText'
                     :tournament="tournament">

    </tournament-form>
    <button type='button' @click="goBack()">Back</button>
  </div>
</template>

<script>
import TournamentForm from './TournamentForm'
import { router } from '../main'

export default {
  name: 'NewTournament',
  data () {
    return {
      buttonText: 'Create',
      tournament: {
        title: '',
        description: '',
        game_id: '',
        picture: '',
        start_date: '',
        teams_quantity: 0,
        players_in_team: 0,
        style: 'deathmatch',
        creator_id: JSON.parse(localStorage.user).id.toString()
      }
    }
  },
  components: {
    TournamentForm
  },
  methods: {
    goBack () {
      router.push('/tournaments')
    }
  }
}
</script>
