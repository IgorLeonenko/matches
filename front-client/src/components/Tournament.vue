<template>
  <div id='tournament'>
    <div v-if="tournament">
      <div class='left'>
        <h3>Tournament {{tournament.title}}</h3>
        <router-link :to="{name: 'tournamentInfo', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentInfo'}">
          Info
        </router-link>
        <router-link :to="{name: 'tournamentTeams', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentTeams'}">
          Teams
        </router-link>
        <router-link :to="{name: 'tournamentMatches', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentMatches'}">
          Matches
        </router-link>
        <router-view :rounds="tournament.rounds"></router-view>
        <router-view :tournament="tournament"></router-view>
        <router-view :teams="tournament.teams"></router-view>
        <button type='button' @click="goBack()">Back</button>
      </div>
    </div>
  </div>
</template>

<script>
  import api from '../api'
  import { router } from '../main'
  import Info from './TournamentInfo'
  export default {
    name: 'Tournament',
    data () {
      return {
        tournament: {}
      }
    },
    components: {
      Info
    },
    created () {
      api.getTournament(this.$route.params.id).then(response => {
        this.tournament = response.data
      })
    },
    methods: {
      goBack () {
        router.push('/tournaments')
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
    width: 70%;
    margin: 0 auto;
  }
  ul {
    list-style: none;
  }
  .left {
    float: left;
  }
  .active {
    color: green;
  }
</style>
